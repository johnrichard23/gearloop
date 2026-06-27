import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/listing_entity.dart';
import '../providers/create_listing_provider.dart';
import '../providers/listings_provider.dart';

/// Form to post new gear (mock submit until Supabase is wired).
class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _minDaysController = TextEditingController(text: '1');

  static const List<String> _categories = [
    'Cameras',
    'Drones',
    'Audio',
    'Lighting',
    'Camping',
    'Sports',
    'Instruments',
    'Events',
    'Tools',
  ];

  String? _selectedCategory;
  double? _selectedLat;
  double? _selectedLng;
  String? _locationLabel;
  final List<_PickedPhoto> _pickedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  static const int _maxPhotos = 5;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _minDaysController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    if (_selectedLat == null || _selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a pickup location')),
      );
      return;
    }

    final listing = ListingEntity(
      id: '',
      hostId: '',
      title: _titleController.text.trim(),
      category: _selectedCategory!,
      pricePerDay: _formatPeso(_priceController.text.trim()),
      location: _locationLabel ?? 'Selected location',
      hostName: 'You',
      rating: 0,
      isVerified: false,
      description: _descriptionController.text.trim(),
      reviewCount: 0,
      depositAmount: _formatPeso(_depositController.text.trim()),
      minRentalDays: _minDaysController.text.trim(),
      isActive: true,
      isPaused: false,
      lat: _selectedLat!,
      lng: _selectedLng!,
    );

    ref.read(createListingProvider.notifier).submitListing(
          listing,
          photos: _pickedPhotos.map((photo) => photo.file).toList(),
        );
  }

  Future<void> _pickPhoto() async {
    if (_pickedPhotos.length >= _maxPhotos) {
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    setState(
      () => _pickedPhotos.add(_PickedPhoto(file: image, bytes: bytes)),
    );
  }

  void _removePhoto(int index) {
    setState(() => _pickedPhotos.removeAt(index));
  }

  Future<void> _pickLocation() async {
    final result = await context.push<LatLng>('/location-picker');
    if (result == null) {
      return;
    }

    setState(() {
      _selectedLat = result.latitude;
      _selectedLng = result.longitude;
    });
    await _reverseGeocodeForLabel(result.latitude, result.longitude);
  }

  Future<void> _reverseGeocodeForLabel(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (!mounted) {
        return;
      }
      setState(() {
        _locationLabel = placemarks.isNotEmpty
            ? _formatPlacemark(placemarks.first)
            : 'Selected location';
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() => _locationLabel = 'Selected location');
    }
  }

  String _formatPlacemark(Placemark placemark) {
    final parts = <String>[
      if (placemark.locality != null && placemark.locality!.isNotEmpty)
        placemark.locality!,
      if (placemark.administrativeArea != null &&
          placemark.administrativeArea!.isNotEmpty)
        placemark.administrativeArea!,
    ];
    if (parts.isEmpty &&
        placemark.subAdministrativeArea != null &&
        placemark.subAdministrativeArea!.isNotEmpty) {
      parts.add(placemark.subAdministrativeArea!);
    }
    return parts.isEmpty ? 'Selected location' : parts.join(', ');
  }

  String _formatPeso(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.startsWith('₱') ? value : '₱$value';
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createListingProvider);
    final hasLocation = _selectedLat != null && _selectedLng != null;
    final canSubmit =
        hasLocation && createState.status != CreateListingStatus.loading;

    ref.listen<CreateListingState>(createListingProvider, (previous, next) {
      if (next.status == CreateListingStatus.success) {
        if (!mounted) return;
        if (next.photoUploadFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Listing created, but some photos failed to upload',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gear posted successfully!')),
          );
        }
        ref.invalidate(listingsProvider);
        ref.read(createListingProvider.notifier).reset();
        context.go('/home');
      } else if (next.status == CreateListingStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.kColorError,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('Post Your Gear'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Photos',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      SizedBox(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...List.generate(_pickedPhotos.length, (index) {
                              final photo = _pickedPhotos[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.kSpacing8,
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.kRadiusMedium,
                                      ),
                                      child: Image.memory(
                                        photo.bytes,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: -6,
                                      right: -6,
                                      child: GestureDetector(
                                        onTap: () => _removePhoto(index),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: AppColors.kColorError,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (_pickedPhotos.length < _maxPhotos)
                              GestureDetector(
                                onTap: _pickPhoto,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.kRadiusMedium,
                                    ),
                                    border: Border.all(
                                      color: AppColors.kColorBorder,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: AppColors.kColorTextSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.kSpacing8),
                      Text(
                        'Add up to 5 photos. Clear photos help renters '
                        'trust your listing.',
                        style: AppTextStyles.kTextCaption.copyWith(
                          color: AppColors.kColorTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.kSpacing24),
                      Text(
                        'Gear Details',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      AppTextField(
                        label: 'Title',
                        controller: _titleController,
                        hint: 'e.g. Sony A7III Camera Body',
                        validator: _validateRequired,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing16),
                      _MultilineTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hint: 'Describe your gear...',
                      ),
                      const SizedBox(height: AppSpacing.kSpacing24),
                      Text(
                        'Category',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      Wrap(
                        spacing: AppSpacing.kSpacing8,
                        runSpacing: AppSpacing.kSpacing8,
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return _CategoryChip(
                            label: category,
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _selectedCategory = category),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.kSpacing24),
                      Text(
                        'Pricing',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      AppTextField(
                        label: 'Price per day',
                        controller: _priceController,
                        hint: '₱0.00',
                        keyboardType: TextInputType.number,
                        validator: _validateRequired,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing16),
                      AppTextField(
                        label: 'Deposit amount',
                        controller: _depositController,
                        hint: '₱0.00',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing24),
                      Text(
                        'Pickup Location',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      _LocationPickerField(
                        label: _locationLabel,
                        onTap: _pickLocation,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing24),
                      Text(
                        'Rental Rules',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      AppTextField(
                        label: 'Minimum rental days',
                        controller: _minDaysController,
                        hint: '1',
                        keyboardType: TextInputType.number,
                        validator: _validateRequired,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.kSpacing16),
              child: AppButton(
                label: 'Post Gear',
                isLoading:
                    createState.status == CreateListingStatus.loading,
                onTap: canSubmit ? _onSubmit : () {},
                color: canSubmit
                    ? AppColors.kColorPrimary
                    : AppColors.kColorTextHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

class _PickedPhoto {
  const _PickedPhoto({
    required this.file,
    required this.bytes,
  });

  final XFile file;
  final Uint8List bytes;
}

class _LocationPickerField extends StatelessWidget {
  const _LocationPickerField({
    required this.label,
    required this.onTap,
  });

  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasLabel = label != null && label!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Pickup location',
          labelStyle: AppTextStyles.kTextLabel,
          filled: true,
          fillColor: AppColors.kColorSurfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
            borderSide: const BorderSide(color: AppColors.kColorBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
            borderSide: const BorderSide(color: AppColors.kColorBorder),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
            vertical: AppSpacing.kSpacing12,
          ),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.kColorPrimary,
          ),
        ),
        child: Text(
          hasLabel ? label! : 'Tap to set pickup location',
          style: AppTextStyles.kTextBodyLarge.copyWith(
            color: hasLabel
                ? AppColors.kColorTextPrimary
                : AppColors.kColorTextHint,
          ),
        ),
      ),
    );
  }
}

/// Multiline field matching [AppTextField] styling (maxLines not on AppTextField yet).
class _MultilineTextField extends StatelessWidget {
  const _MultilineTextField({
    required this.label,
    required this.controller,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: AppTextStyles.kTextBodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.kTextLabel,
        hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorTextHint,
        ),
        filled: true,
        fillColor: AppColors.kColorSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorPrimary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.kColorPrimary
          : AppColors.kColorSurfaceVariant,
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing12,
            vertical: AppSpacing.kSpacing8,
          ),
          child: Text(
            label,
            style: AppTextStyles.kTextLabel.copyWith(
              color: isSelected
                  ? AppColors.kColorSurface
                  : AppColors.kColorTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
