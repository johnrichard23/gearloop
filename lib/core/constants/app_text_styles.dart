import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Rentra design tokens — typography (Theme 2: Ocean & Coral).
abstract final class AppTextStyles {
  AppTextStyles._();

  // Headings — kColorTextPrimary
  static const TextStyle kTextHeading1 = TextStyle(
    fontSize: 28, // Screen titles, hero gear names
    fontWeight: FontWeight.w700,
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextHeading2 = TextStyle(
    fontSize: 22, // Section headers, listing detail titles
    fontWeight: FontWeight.w700,
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextHeading3 = TextStyle(
    fontSize: 18, // Card titles, modal headers
    fontWeight: FontWeight.w600,
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextHeading4 = TextStyle(
    fontSize: 16, // Subsection titles, list group headers
    fontWeight: FontWeight.w600,
    color: AppColors.kColorTextPrimary,
  );

  // Body — primary for emphasis, secondary for supporting copy
  static const TextStyle kTextBodyLarge = TextStyle(
    fontSize: 16, // Primary paragraphs, booking summaries
    fontWeight: FontWeight.w400,
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextBodyMedium = TextStyle(
    fontSize: 14, // Descriptions, host bios, form helper text
    fontWeight: FontWeight.w400,
    color: AppColors.kColorTextSecondary,
  );

  static const TextStyle kTextBodySmall = TextStyle(
    fontSize: 12, // Metadata, secondary list details
    fontWeight: FontWeight.w400,
    color: AppColors.kColorTextSecondary,
  );

  static const TextStyle kTextLabel = TextStyle(
    fontSize: 12, // Form labels, filter chips, badges
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.kColorTextSecondary,
  );

  static const TextStyle kTextCaption = TextStyle(
    fontSize: 11, // Timestamps, footnotes, legal fine print
    fontWeight: FontWeight.w400,
    color: AppColors.kColorTextSecondary,
  );

  static const TextStyle kTextButton = TextStyle(
    fontSize: 15, // Primary and secondary button labels
    fontWeight: FontWeight.w600,
    color: AppColors.kColorTextPrimary,
  );

  // Price — kColorAccent
  static const TextStyle kTextPrice = TextStyle(
    fontSize: 20, // Daily rate on listing detail
    fontWeight: FontWeight.w700,
    color: AppColors.kColorAccent,
  );

  static const TextStyle kTextPriceSmall = TextStyle(
    fontSize: 14, // Price on listing cards and booking rows
    fontWeight: FontWeight.w600,
    color: AppColors.kColorAccent,
  );
}
