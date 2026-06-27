import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/data/repositories/bookings_repository_impl.dart';
import '../../domain/entities/listing_entity.dart';

/// Gear listing detail (dummy pricing until booking flow exists).
class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({
    required this.listing,
    super.key,
  });

  final ListingEntity listing;

  static const double _platformFeeRate = 0.12;

  String get _totalForOneDay {
    final daily = _parsePesoAmount(listing.pricePerDay);
    final total = (daily * (1 + _platformFeeRate)).round();
    return _formatPeso(total);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Supabase.instance.client.auth.currentUser?.id;
    final isOwnListing = currentUserId == listing.hostId;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PhotoSection(
                    photoUrls: listing.photoUrls,
                    onBack: () => context.pop(),
                  ),
                  if (isOwnListing)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.kSpacing16,
                        AppSpacing.kSpacing16,
                        AppSpacing.kSpacing16,
                        0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.kSpacing12),
                        decoration: BoxDecoration(
                          color: AppColors.kColorPrimaryFaded,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.kRadiusMedium,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.kColorPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: AppSpacing.kSpacing8),
                            Expanded(
                              child: Text(
                                'Viewing as host — this is how renters '
                                'see your listing below',
                                style: AppTextStyles.kTextBodySmall.copyWith(
                                  color: AppColors.kColorPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: AppTextStyles.kTextHeading2,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing8),
                        _CategoryChip(label: listing.category),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        _HostInfoRow(listing: listing),
                        const Divider(color: AppColors.kColorBorder),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        _PricingCard(
                          pricePerDay: listing.pricePerDay,
                          depositAmount: listing.depositAmount,
                          totalForOneDay: _totalForOneDay,
                        ),
                        const Divider(color: AppColors.kColorBorder),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        Text(
                          'About this gear',
                          style: AppTextStyles.kTextHeading4,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing8),
                        Text(
                          listing.description,
                          style: AppTextStyles.kTextBodyMedium.copyWith(
                            color: AppColors.kColorTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        _PickupLocationSection(
                          listing: listing,
                          isOwnListing: isOwnListing,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOwnListing)
            _OwnListingBottomBar(
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit coming soon!')),
                );
              },
            )
          else
            _BottomBar(
              pricePerDay: listing.pricePerDay,
              onBookNow: () {
                context.push(
                  '/booking-request',
                  extra: listing,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PickupLocationSection extends StatefulWidget {
  const _PickupLocationSection({
    required this.listing,
    required this.isOwnListing,
  });

  final ListingEntity listing;
  final bool isOwnListing;

  @override
  State<_PickupLocationSection> createState() => _PickupLocationSectionState();
}

class _PickupLocationSectionState extends State<_PickupLocationSection> {
  final _bookingsRepository = BookingsRepositoryImpl();
  bool _isLoading = true;
  bool _hasConfirmedBooking = false;

  @override
  void initState() {
    super.initState();
    _loadBookingStatus();
  }

  Future<void> _loadBookingStatus() async {
    if (widget.isOwnListing) {
      setState(() => _isLoading = false);
      return;
    }

    final renterId = Supabase.instance.client.auth.currentUser?.id;
    if (renterId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final result = await _bookingsRepository.hasConfirmedBookingForListing(
      listingId: widget.listing.id,
      renterId: renterId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _hasConfirmedBooking = result.fold((_) => false, (value) => value);
      _isLoading = false;
    });
  }

  bool get _showExactLocation =>
      widget.isOwnListing || _hasConfirmedBooking;

  LatLng get _pickupLatLng =>
      LatLng(widget.listing.lat, widget.listing.lng);

  void _openFullscreenMap() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.kSpacing16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pickupLatLng,
                zoom: 16,
              ),
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: _pickupLatLng,
                ),
              },
              zoomControlsEnabled: false,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Location',
          style: AppTextStyles.kTextHeading4,
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.kColorAccent,
              size: AppSpacing.kIconMedium,
            ),
            const SizedBox(width: AppSpacing.kSpacing8),
            Expanded(
              child: Text(
                widget.listing.location,
                style: AppTextStyles.kTextBodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        Text(
          _showExactLocation
              ? 'Exact pickup location'
              : 'General area — exact location shown after '
                  'booking is confirmed',
          style: AppTextStyles.kTextBodySmall.copyWith(
            color: AppColors.kColorTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: _isLoading
                ? const ColoredBox(
                    color: AppColors.kColorSurfaceVariant,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _showExactLocation
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _pickupLatLng,
                          zoom: 15,
                        ),
                        mapType: MapType.normal,
                        markers: {
                          Marker(
                            markerId: const MarkerId('pickup'),
                            position: _pickupLatLng,
                          ),
                        },
                        zoomControlsEnabled: false,
                        onTap: (_) => _openFullscreenMap(),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _pickupLatLng,
                          zoom: 13,
                        ),
                        mapType: MapType.normal,
                        onMapCreated: (controller) {
                          debugPrint(
                            'GENERAL AREA MAP CREATED SUCCESSFULLY',
                          );
                          debugPrint(
                            'CAMERA TARGET: lat=${_pickupLatLng.latitude}, lng=${_pickupLatLng.longitude}',
                          );
                        },
                        circles: {
                          Circle(
                            circleId: const CircleId('pickup_area'),
                            center: _pickupLatLng,
                            radius: 800,
                            fillColor: AppColors.kColorPrimary.withValues(
                              alpha: 0.15,
                            ),
                            strokeColor: AppColors.kColorPrimary.withValues(
                              alpha: 0.4,
                            ),
                            strokeWidth: 1,
                          ),
                        },
                        zoomControlsEnabled: false,
                      ),
          ),
        ),
      ],
    );
  }
}

class _PhotoSection extends StatefulWidget {
  const _PhotoSection({
    required this.photoUrls,
    required this.onBack,
  });

  final List<String> photoUrls;
  final VoidCallback onBack;

  @override
  State<_PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<_PhotoSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhotos = widget.photoUrls.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasPhotos)
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: widget.photoUrls.length,
                  itemBuilder: (context, index) {
                    return _DetailNetworkImage(
                      imageUrl: widget.photoUrls[index],
                    );
                  },
                )
              else
                const ColoredBox(
                  color: AppColors.kColorSurfaceVariant,
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.kColorTextHint,
                      size: AppSpacing.kIconXLarge,
                    ),
                  ),
                ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSpacing.kSpacing8,
                left: AppSpacing.kSpacing8,
                child: IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.kColorSurface,
                    foregroundColor: AppColors.kColorTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasPhotos && widget.photoUrls.length > 1) ...[
          const SizedBox(height: AppSpacing.kSpacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.photoUrls.length, (index) {
              final isActive = index == _currentPage;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: isActive ? 8 : 6,
                  height: isActive ? 8 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.kColorPrimary
                        : AppColors.kColorBorder,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
        ],
      ],
    );
  }
}

class _DetailNetworkImage extends StatelessWidget {
  const _DetailNetworkImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const ColoredBox(
          color: AppColors.kColorSurfaceVariant,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(
          color: AppColors.kColorSurfaceVariant,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColors.kColorTextHint,
              size: AppSpacing.kIconXLarge,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimaryFaded,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}

class _HostInfoRow extends StatelessWidget {
  const _HostInfoRow({required this.listing});

  final ListingEntity listing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.kColorSurfaceVariant,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.kColorTextHint,
            size: AppSpacing.kIconMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(listing.hostName, style: AppTextStyles.kTextBodyMedium),
              const SizedBox(height: AppSpacing.kSpacing4),
              Row(
                children: [
                  if (listing.isVerified) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.kSpacing8,
                        vertical: AppSpacing.kSpacing2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kColorPrimaryFaded,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.kRadiusSmall),
                      ),
                      child: Text(
                        'Verified ✓',
                        style: AppTextStyles.kTextLabel.copyWith(
                          color: AppColors.kColorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.kSpacing8),
                  ],
                  const Icon(
                    Icons.star,
                    size: AppSpacing.kIconSmall,
                    color: AppColors.kColorWarning,
                  ),
                  const SizedBox(width: AppSpacing.kSpacing4),
                  Text(
                    '${listing.rating.toStringAsFixed(1)} (${listing.reviewCount} reviews)',
                    style: AppTextStyles.kTextBodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.pricePerDay,
    required this.depositAmount,
    required this.totalForOneDay,
  });

  final String pricePerDay;
  final String depositAmount;
  final String totalForOneDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      decoration: BoxDecoration(
        color: AppColors.kColorSurfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
      ),
      child: Column(
        children: [
          _PricingRow(
            label: 'Price per day',
            value: pricePerDay,
            valueStyle: AppTextStyles.kTextPrice,
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          _PricingRow(label: 'Deposit', value: depositAmount),
          const SizedBox(height: AppSpacing.kSpacing8),
          const _PricingRow(label: 'Platform fee', value: '12%'),
          const Divider(color: AppColors.kColorBorder),
          const SizedBox(height: AppSpacing.kSpacing8),
          _PricingRow(
            label: 'Total for 1 day',
            value: totalForOneDay,
            valueStyle: AppTextStyles.kTextHeading3.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.kTextBodyMedium),
        Text(
          value,
          style: valueStyle ?? AppTextStyles.kTextBodyMedium,
        ),
      ],
    );
  }
}

class _OwnListingBottomBar extends StatelessWidget {
  const _OwnListingBottomBar({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kColorSurface,
        border: Border(top: BorderSide(color: AppColors.kColorBorder)),
      ),
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.kColorTextSecondary,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.kSpacing8),
            Expanded(
              child: Text(
                'This is your listing',
                style: AppTextStyles.kTextBodySmall.copyWith(
                  color: AppColors.kColorTextSecondary,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: AppButton(
                label: 'Edit',
                isOutlined: true,
                onTap: onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pricePerDay,
    required this.onBookNow,
  });

  final String pricePerDay;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kColorSurface,
        border: Border(top: BorderSide(color: AppColors.kColorBorder)),
      ),
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pricePerDay, style: AppTextStyles.kTextPrice),
                Text('/day', style: AppTextStyles.kTextCaption),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 140,
              child: AppButton(
                label: 'Book Now',
                onTap: onBookNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _parsePesoAmount(String amount) {
  final digits = amount.replaceAll(RegExp(r'[^\d]'), '');
  return int.parse(digits);
}

String _formatPeso(int amount) {
  final buffer = StringBuffer('₱');
  final text = amount.toString();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[i]);
  }
  return buffer.toString();
}
