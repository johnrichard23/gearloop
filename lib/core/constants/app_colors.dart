import 'package:flutter/material.dart';

/// Rentra design tokens — earthy palette: deep forest green, warm sand, gold.
abstract final class AppColors {
  AppColors._();

  // Primary — Forest green
  static const Color kColorPrimary = Color(0xFF2A5251); // Buttons, navbar, links, prices
  static const Color kColorPrimaryLight = Color(0xFF3D6B68); // Hover and active states
  static const Color kColorPrimaryFaded = Color(0xFFE4E9E3); // Sage tinted backgrounds, chips

  // Accent — Gold (fills and icons only; not for text on cream)
  static const Color kColorAccent = Color(0xFFC8A26C); // Highlights, markers, main action fill
  static const Color kColorAccentLight = Color(0xFFF3E9D8); // Gold tinted backgrounds

  // On-colors — text and icons placed on a filled surface
  static const Color kColorOnPrimary = Color(0xFFFFFFFF); // On primary, error, success fills
  static const Color kColorOnAccent = Color(0xFF1E3A39); // On gold fill (white fails contrast)

  // Background
  static const Color kColorBackground = Color(0xFFF3EFEA); // App background — warm cream
  static const Color kColorSurface = Color(0xFFFBF9F5); // Cards and sheets
  static const Color kColorSurfaceVariant = Color(0xFFECE5DA); // Secondary surfaces, input fields

  // Text
  static const Color kColorTextPrimary = Color(0xFF1F2D2B); // Headings, gear names
  static const Color kColorTextSecondary = Color(0xFF5E6A66); // Descriptions, metadata
  static const Color kColorTextHint = Color(0xFF7C8680); // Placeholder text, disabled

  // Semantic
  static const Color kColorSuccess = Color(0xFF2E7A47); // Completed bookings, verified badges
  static const Color kColorSuccessLight = Color(0xFFE3F0E5); // Success backgrounds
  static const Color kColorWarning = Color(0xFFA65E0C); // Pending states, deposit
  static const Color kColorWarningLight = Color(0xFFF8E9CF); // Warning backgrounds
  static const Color kColorError = Color(0xFFB54A3A); // Disputes, damage, cancellations
  static const Color kColorErrorLight = Color(0xFFF6E0DB); // Error backgrounds

  // Border
  static const Color kColorBorder = Color(0xFFE2DBCF); // Default borders
  static const Color kColorBorderDark = Color(0xFFCFC6B8); // Emphasized borders
}
