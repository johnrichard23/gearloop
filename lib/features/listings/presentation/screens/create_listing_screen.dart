import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/listing_entity.dart';
import '../providers/create_listing_provider.dart';

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
  final _locationController = TextEditingController();
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _locationController.dispose();
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

    final listing = ListingEntity(
      id: '',
      hostId: 'host-placeholder',
      title: _titleController.text.trim(),
      category: _selectedCategory!,
      pricePerDay: _formatPeso(_priceController.text.trim()),
      location: _locationController.text.trim(),
      hostName: 'You',
      rating: 0,
      isVerified: false,
      description: _descriptionController.text.trim(),
      reviewCount: 0,
      depositAmount: _formatPeso(_depositController.text.trim()),
      minRentalDays: _minDaysController.text.trim(),
      isActive: true,
      isPaused: false,
      lat: 0,
      lng: 0,
    );

    ref.read(createListingProvider.notifier).submitListing(listing);
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

    ref.listen<CreateListingState>(createListingProvider, (previous, next) {
      if (next.status == CreateListingStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gear posted successfully!')),
        );
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
                      AppTextField(
                        label: 'Location label',
                        controller: _locationController,
                        hint: 'e.g. Legazpi City, Albay',
                        validator: _validateRequired,
                      ),
                      const SizedBox(height: AppSpacing.kSpacing8),
                      Text(
                        'Exact coordinates will be set automatically in a future update.',
                        style: AppTextStyles.kTextCaption.copyWith(
                          color: AppColors.kColorTextHint,
                        ),
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
                onTap: _onSubmit,
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
