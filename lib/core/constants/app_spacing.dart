/// GearLoop design tokens — spacing, radius, and icon sizes.
abstract final class AppSpacing {
  AppSpacing._();

  // Spacing scale (logical pixels)
  static const double kSpacing2 = 2.0; // Hairline gaps, tight icon padding
  static const double kSpacing4 = 4.0; // Inline gaps between icon and label
  static const double kSpacing8 = 8.0; // Compact list item padding
  static const double kSpacing12 = 12.0; // Chip padding, small card insets
  static const double kSpacing16 = 16.0; // Default screen and card padding
  static const double kSpacing20 = 20.0; // Section spacing within a screen
  static const double kSpacing24 = 24.0; // Space between stacked sections
  static const double kSpacing32 = 32.0; // Large section breaks
  static const double kSpacing40 = 40.0; // Hero and empty-state vertical rhythm
  static const double kSpacing48 = 48.0; // Bottom sheet and modal padding
  static const double kSpacing64 = 64.0; // Page-level top/bottom breathing room

  // Border radius
  static const double kRadiusSmall = 6.0; // Chips, small buttons, tags
  static const double kRadiusMedium = 10.0; // Inputs, buttons, list tiles
  static const double kRadiusLarge = 16.0; // Cards, sheets, image thumbnails
  static const double kRadiusXLarge = 24.0; // Modals, featured cards
  static const double kRadiusCircular = 999.0; // Avatars, FABs, pill buttons

  // Icon sizes
  static const double kIconSmall = 16.0; // Inline icons, dense lists
  static const double kIconMedium = 20.0; // Standard toolbar and row icons
  static const double kIconLarge = 24.0; // Primary action icons
  static const double kIconXLarge = 32.0; // Empty states, feature highlights
}
