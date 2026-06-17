import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_spacing.dart';
import 'core/router/app_router.dart';

/// Root widget: routing + theme.
class GearLoopApp extends StatelessWidget {
  const GearLoopApp({super.key});

  static final ThemeData _theme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.kColorPrimary,
    scaffoldBackgroundColor: AppColors.kColorBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.kColorPrimary,
      secondary: AppColors.kColorAccent,
      background: AppColors.kColorBackground,
      surface: AppColors.kColorSurface,
      error: AppColors.kColorError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.kColorPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kColorPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.kColorSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        borderSide: const BorderSide(color: AppColors.kColorBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        borderSide: const BorderSide(color: AppColors.kColorBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        borderSide: const BorderSide(color: AppColors.kColorPrimary),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GearLoop',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: _theme,
    );
  }
}
