import 'package:flutter/material.dart';

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

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Icon? buttonIcon;
  final Color? btnColor;
  final BorderRadiusType radius;
  final double? width;

  const MyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonIcon,
    this.btnColor = const Color(0xFF5A7863),
    this.radius = BorderRadiusType.small,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        icon: buttonIcon,
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return btnColor?.withValues(alpha: 0.8) ??
                  const Color(0xFF5A7863).withValues(alpha: 0.8);
            }
            return btnColor ?? const Color(0xFF5A7863);
          }),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          overlayColor: WidgetStateProperty.all<Color>(
            Colors.white.withValues(alpha: 0.2),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: radius.borderRadius),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          ),
        ),
        label: Text(text),
      ),
    );
  }
}
