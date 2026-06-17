import 'package:flutter/material.dart';

/// GearLoop design tokens — Theme 2: Ocean & Coral.
abstract final class AppColors {
  AppColors._();

  // Primary — Ocean Blue
  static const Color kColorPrimary = Color(0xFF1A5FA8); // Buttons, navbar, links
  static const Color kColorPrimaryLight = Color(0xFF2B7DD4); // Hover and active states
  static const Color kColorPrimaryFaded = Color(0xFFE8F2FC); // Blue tinted backgrounds, chips

  // Accent — Coral
  static const Color kColorAccent = Color(0xFFE8523A); // CTAs, prices, highlights
  static const Color kColorAccentLight = Color(0xFFFDECEA); // Coral tinted backgrounds

  // Background
  static const Color kColorBackground = Color(0xFFFFF9F8); // App background — warm cool white
  static const Color kColorSurface = Color(0xFFFFFFFF); // Cards and sheets
  static const Color kColorSurfaceVariant = Color(0xFFF4F6FA); // Secondary surfaces, input fields

  // Text
  static const Color kColorTextPrimary = Color(0xFF1A1A2E); // Headings, gear names
  static const Color kColorTextSecondary = Color(0xFF5A6275); // Descriptions, metadata
  static const Color kColorTextHint = Color(0xFF9BA3B2); // Placeholder text, disabled

  // Semantic
  static const Color kColorSuccess = Color(0xFF1B6B45); // Completed bookings, verified badges
  static const Color kColorSuccessLight = Color(0xFFE8F5EE); // Success backgrounds
  static const Color kColorWarning = Color(0xFFF5A623); // Pending states, deposit
  static const Color kColorWarningLight = Color(0xFFFFF3D6); // Warning backgrounds
  static const Color kColorError = Color(0xFFC0392B); // Disputes, damage, cancellations
  static const Color kColorErrorLight = Color(0xFFFDECEA); // Error backgrounds

  // Border
  static const Color kColorBorder = Color(0xFFE2E8F0); // Default borders
  static const Color kColorBorderDark = Color(0xFFCBD5E1); // Emphasized borders
}
