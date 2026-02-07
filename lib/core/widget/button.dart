import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';

enum BorderRadiusType { small, medium, large, extraLarge, full }

extension BorderRadiusExtension on BorderRadiusType {
  double get value {
    switch (this) {
      case BorderRadiusType.small:
        return 4.0;
      case BorderRadiusType.medium:
        return 8.0;
      case BorderRadiusType.large:
        return 12.0;
      case BorderRadiusType.extraLarge:
        return 16.0;
      case BorderRadiusType.full:
        return 999.0;
    }
  }

  BorderRadius get borderRadius {
    return BorderRadius.all(Radius.circular(value));
  }
}

class ButtonColor extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BorderRadiusType borderRadius;
  final Icon? buttonIcon;
  final double? width;
  final Color? btnColor;

  const ButtonColor({
    super.key,
    required this.text,
    this.borderRadius = BorderRadiusType.small,
    this.onPressed,
    this.buttonIcon,
    this.width,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = btnColor ?? const Color(0xFF2F4BB9);

    return SizedBox(
      width: width,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: backgroundColor.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius.borderRadius,
          splashColor: Colors.blue.withValues(alpha: 0.4),
          highlightColor: Colors.white.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonIcon != null) ...[
                  buttonIcon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonOutline extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? buttonIcon;
  final double? width;
  final Color? outlineColor;
  final Color? textColor;
  final double? borderWidth;

  const ButtonOutline({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonIcon,
    this.width,
    this.outlineColor,
    this.textColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderCol = outlineColor ?? AppColors.light.primary;
    final Color textCol = textColor ?? AppColors.light.textPrimary;

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: borderCol.withValues(alpha: 0.3),
          highlightColor: borderCol.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderCol, width: borderWidth ?? 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (buttonIcon != null) ...[
                  buttonIcon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: textCol,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
