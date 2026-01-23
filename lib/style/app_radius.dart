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
