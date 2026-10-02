import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/listing_entity.dart';

/// Map of the given listings, one marker each.
class BrowseMapView extends StatelessWidget {
  const BrowseMapView({required this.listings, super.key});

  final List<ListingEntity> listings;

  static const LatLng _sorsogonCity = LatLng(12.9734, 124.0067);

  static bool _hasValidLocation(ListingEntity listing) {
    return !(listing.lat == 0.0 && listing.lng == 0.0);
  }

  LatLng _mapCenter() {
    final validListings = listings.where(_hasValidLocation).toList();
    if (validListings.isEmpty) {
      return _sorsogonCity;
    }

    final latSum = validListings.fold<double>(
      0,
      (sum, listing) => sum + listing.lat,
    );
    final lngSum = validListings.fold<double>(
      0,
      (sum, listing) => sum + listing.lng,
    );
    return LatLng(latSum / validListings.length, lngSum / validListings.length);
  }

  Set<Marker> _buildMarkers(BuildContext context) {
    return listings.where(_hasValidLocation).map((listing) {
      return Marker(
        markerId: MarkerId(listing.id),
        position: LatLng(listing.lat, listing.lng),
        infoWindow: InfoWindow(
          title: listing.title,
          snippet: '${listing.pricePerDay}/day',
          onTap: () => context.push('/listing/${listing.id}', extra: listing),
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final center = _mapCenter();
    final markers = _buildMarkers(context);

    return GoogleMap(
      key: ValueKey('${center.latitude}_${center.longitude}_${markers.length}'),
      initialCameraPosition: CameraPosition(target: center, zoom: 12),
      mapType: MapType.normal,
      markers: markers,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }
}
