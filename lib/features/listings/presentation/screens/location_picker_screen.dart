import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Full-screen map picker: drag map under a fixed pin to set pickup location.
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({
    this.initialLat,
    this.initialLng,
    super.key,
  });

  final double? initialLat;
  final double? initialLng;

  static const LatLng kSorsogonCity = LatLng(12.9734, 124.0067);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const double _defaultZoom = 15;

  GoogleMapController? _mapController;
  CameraPosition? _initialCamera;
  LatLng _currentCenter = LocationPickerScreen.kSorsogonCity;
  String _areaLabel = 'Drag map to adjust pin location';
  bool _permissionDenied = false;
  bool _isMapReady = false;
  bool _isGeocodingLabel = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    LatLng target;

    if (widget.initialLat != null && widget.initialLng != null) {
      target = LatLng(widget.initialLat!, widget.initialLng!);
    } else {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        target = LocationPickerScreen.kSorsogonCity;
        _permissionDenied = true;
      } else {
        try {
          final position = await Geolocator.getCurrentPosition();
          target = LatLng(position.latitude, position.longitude);
        } on Exception {
          target = LocationPickerScreen.kSorsogonCity;
          _permissionDenied = true;
        }
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentCenter = target;
      _initialCamera = CameraPosition(
        target: target,
        zoom: _defaultZoom,
      );
      _isMapReady = true;
    });

    await _reverseGeocode(target);
  }

  Future<void> _reverseGeocode(LatLng point) async {
    setState(() => _isGeocodingLabel = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _areaLabel = placemarks.isNotEmpty
            ? _formatPlacemark(placemarks.first)
            : 'Drag map to adjust pin location';
        _isGeocodingLabel = false;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _areaLabel = 'Drag map to adjust pin location';
        _isGeocodingLabel = false;
      });
    }
  }

  Future<void> _useMyLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) {
        return;
      }
      setState(() => _permissionDenied = true);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      _currentCenter = target;
      await _mapController?.animateCamera(
        CameraUpdate.newLatLng(target),
      );
      if (!mounted) {
        return;
      }
      setState(() => _permissionDenied = false);
      await _reverseGeocode(target);
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get your current location.'),
        ),
      );
    }
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Couldn't find that location. Try a different search.",
            ),
          ),
        );
        return;
      }

      final location = locations.first;
      final target = LatLng(location.latitude, location.longitude);
      _currentCenter = target;
      await _mapController?.animateCamera(
        CameraUpdate.newLatLng(target),
      );
      if (!mounted) {
        return;
      }
      _searchFocusNode.unfocus();
      await _reverseGeocode(target);
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't find that location. Try a different search.",
          ),
        ),
      );
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
  }

  void _onCameraIdle() {
    _reverseGeocode(_currentCenter);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Pickup Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          if (_isMapReady && _initialCamera != null)
            GoogleMap(
              initialCameraPosition: _initialCamera!,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
            )
          else
            const Center(child: CircularProgressIndicator()),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Icon(
                Icons.location_on,
                size: 48,
                color: AppColors.kColorAccent,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _SearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onSubmitted: (_) => _searchLocation(),
              onClear: () {
                _searchController.clear();
                _searchFocusNode.unfocus();
              },
            ),
          ),
          if (_permissionDenied)
            Positioned(
              top: 72,
              left: AppSpacing.kSpacing16,
              right: AppSpacing.kSpacing16,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
                color: AppColors.kColorWarningLight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.kSpacing12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_off_outlined,
                        color: AppColors.kColorWarning,
                        size: AppSpacing.kIconMedium,
                      ),
                      const SizedBox(width: AppSpacing.kSpacing8),
                      Expanded(
                        child: Text(
                          'Location access was denied. '
                          'Enable it to use your current position.',
                          style: AppTextStyles.kTextBodySmall,
                        ),
                      ),
                      TextButton(
                        onPressed: Geolocator.openAppSettings,
                        child: const Text('Settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: AppSpacing.kSpacing16,
            bottom: 120,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              color: AppColors.kColorSurface,
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  icon: const Icon(
                    Icons.my_location,
                    color: AppColors.kColorPrimary,
                  ),
                  onPressed: _useMyLocation,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.kColorSurface,
                border: Border(
                  top: BorderSide(color: AppColors.kColorBorder),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.kSpacing16),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isGeocodingLabel)
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.kSpacing12,
                        ),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    Text(
                      _areaLabel,
                      style: AppTextStyles.kTextBodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.kSpacing12),
                    AppButton(
                      label: 'Confirm Location',
                      onTap: () => context.pop(_currentCenter),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final hasText = controller.text.isNotEmpty;

          return Row(
            children: [
              const Icon(
                Icons.search,
                color: AppColors.kColorTextSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: AppTextStyles.kTextBodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search for an area...',
                    hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
                      color: AppColors.kColorTextHint,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSubmitted,
                ),
              ),
              if (hasText)
                SizedBox(
                  width: 36,
                  height: 36,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.kColorTextHint,
                      size: 18,
                    ),
                    onPressed: onClear,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
