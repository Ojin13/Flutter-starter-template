import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors>{
  final Color customColor1;
  final Color customColor2;

  const AppColors({
    required this.customColor1,
    required this.customColor2,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? customColor1,
    Color? customColor2,
}) {
    return AppColors(
      customColor1: customColor1 ?? this.customColor1,
      customColor2: customColor2 ?? this.customColor2,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      customColor1: Color.lerp(customColor1, other.customColor1, t)!,
      customColor2: Color.lerp(customColor2, other.customColor2, t)!,
    );
  }
}
