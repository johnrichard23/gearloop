import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Rentra design tokens — typography (teal palette).
abstract final class AppTextStyles {
  AppTextStyles._();

  /// Bricolage Grotesque (variable: weight, width and optical size axes).
  /// Used for display text and the two largest headings only.
  static const String kFontHeadline = 'BricolageGrotesque';

  // Headings — kColorTextPrimary
  static const TextStyle kTextDisplay = TextStyle(
    fontFamily: kFontHeadline,
    fontSize: 36, // Onboarding and launch headlines
    fontWeight: FontWeight.w800,
    fontVariations: [FontVariation('wght', 800), FontVariation('opsz', 36)],
    height: 1.1,
    letterSpacing: -0.5,
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextHeading1 = TextStyle(
    fontFamily: kFontHeadline,
    fontSize: 28, // Screen titles, hero gear names
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700), FontVariation('opsz', 28)],
    color: AppColors.kColorTextPrimary,
  );

  static const TextStyle kTextHeading2 = TextStyle(
    fontFamily: kFontHeadline,
    fontSize: 22, // Section headers, listing detail titles
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700), FontVariation('opsz', 22)],
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

  // Price — kColorPrimary (accent is too low-contrast for text)
  static const TextStyle kTextPrice = TextStyle(
    fontSize: 20, // Daily rate on listing detail
    fontWeight: FontWeight.w700,
    color: AppColors.kColorPrimary,
  );

  static const TextStyle kTextPriceSmall = TextStyle(
    fontSize: 14, // Price on listing cards and booking rows
    fontWeight: FontWeight.w600,
    color: AppColors.kColorPrimary,
  );
}
