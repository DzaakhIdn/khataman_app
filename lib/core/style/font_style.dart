import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppFontSizes {
  static const double h1 = 24;
  static const double h2 = 22;
  static const double h3 = 20;

  static const double bodyLg = 18;
  static const double bodyMd = 16;
  static const double bodySm = 14;

  static const double button = 16;
  static const double caption = 14;
}

class AppLineHeights {
  static const double tight = 1.2;
  static const double normal = 1.4;
  static const double relaxed = 1.6;
}

class AppTextStyles {
  static TextStyle h1(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.h1,
      fontWeight: FontWeight.w700,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle h2(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.h2,
      fontWeight: FontWeight.w700,
      height: AppLineHeights.tight,
      color: c.textPrimary,
    );
  }

  static TextStyle h3(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.h3,
      fontWeight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyLg(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodyLg,
      fontWeight: FontWeight.w400,
      height: AppLineHeights.relaxed,
      color: c.textPrimary,
    );
  }

  static TextStyle bodyMd(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodyMd,
      fontWeight: FontWeight.w400,
      height: AppLineHeights.relaxed,
      color: c.textPrimary,
    );
  }

  static TextStyle bodySm(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodySm,
      fontWeight: FontWeight.w400,
      height: AppLineHeights.normal,
      color: c.textSecondary,
    );
  }

  static TextStyle caption(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.caption,
      fontWeight: FontWeight.w400,
      height: AppLineHeights.normal,
      color: c.textSecondary,
    );
  }

  static TextStyle button() {
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.button,
      fontWeight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: Colors.white,
    );
  }

  static TextStyle bodyStrong(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodyMd,
      fontWeight: FontWeight.w600,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle label(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodySm,
      fontWeight: FontWeight.w500,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }

  static TextStyle onBoarding(BuildContext context) {
    final c = AppColors.of(context);
    return GoogleFonts.quicksand(
      fontSize: AppFontSizes.bodyMd,
      fontWeight: FontWeight.w400,
      height: AppLineHeights.normal,
      color: c.textPrimary,
    );
  }
}
