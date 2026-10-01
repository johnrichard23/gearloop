import 'package:flutter/material.dart';

/// Rentra design tokens — teal palette (mirrors the Figma `Rentra Colors` collection).
abstract final class AppColors {
  AppColors._();

  // Primary — Teal
  static const Color kColorPrimary = Color(0xFF1F6F63); // Buttons, navbar, links, prices
  static const Color kColorPrimaryLight = Color(0xFF2A8576); // Hover and active states
  static const Color kColorPrimaryFaded = Color(0xFFE4F1EE); // Teal tinted backgrounds, chips

  // Accent — Sage (fills and icons only; not for text on white)
  static const Color kColorAccent = Color(0xFF6FA897); // Highlights, markers
  static const Color kColorAccentLight = Color(0xFFE8F3EF); // Sage tinted backgrounds

  // On-colors — text and icons placed on a filled surface
  static const Color kColorOnPrimary = Color(0xFFFFFFFF); // On primary, error, dark fills
  static const Color kColorOnAccent = Color(0xFF0B2F29); // On accent fill (white fails contrast)

  // Background
  static const Color kColorBackground = Color(0xFFF7FAF9); // App background
  static const Color kColorSurface = Color(0xFFFFFFFF); // Cards and sheets
  static const Color kColorSurfaceVariant = Color(0xFFF1F5F4); // Secondary surfaces, input fields

  // Text
  static const Color kColorTextPrimary = Color(0xFF1A1A2E); // Headings, gear names
  static const Color kColorTextSecondary = Color(0xFF6B7280); // Descriptions, metadata
  static const Color kColorTextHint = Color(0xFF9CA3AF); // Placeholder text, disabled

  // Semantic
  static const Color kColorSuccess = Color(0xFF16A34A); // Completed bookings, verified badges
  static const Color kColorSuccessLight = Color(0xFFDCFCE7); // Success backgrounds
  static const Color kColorWarning = Color(0xFFD97706); // Pending states, deposit
  static const Color kColorWarningLight = Color(0xFFFEF3C7); // Warning backgrounds
  static const Color kColorError = Color(0xFFC0392B); // Disputes, damage, cancellations
  static const Color kColorErrorLight = Color(0xFFFDECEA); // Error backgrounds

  // Border
  static const Color kColorBorder = Color(0xFFE5E7EB); // Default borders
  static const Color kColorBorderDark = Color(0xFFD1D5DB); // Emphasized borders
}
