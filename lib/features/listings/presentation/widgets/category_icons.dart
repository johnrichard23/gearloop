import 'package:flutter/material.dart';

/// The icon for a listing category, shared by Home and the search screen so
/// the same category always looks the same. Unknown categories get a generic
/// icon.
IconData categoryIcon(String category) {
  return switch (category) {
    'Cameras' => Icons.camera_alt_outlined,
    'Drones' => Icons.flight_outlined,
    'Audio' => Icons.mic_outlined,
    'Lighting' => Icons.lightbulb_outline,
    'Camping' => Icons.cabin_outlined,
    'Sports' => Icons.pedal_bike_outlined,
    'Adventure' => Icons.surfing,
    'Tools' => Icons.handyman_outlined,
    'Fashion' => Icons.checkroom_outlined,
    'Utility' => Icons.local_shipping_outlined,
    'Instruments' => Icons.music_note_outlined,
    'Events' => Icons.celebration_outlined,
    _ => Icons.category_outlined,
  };
}
