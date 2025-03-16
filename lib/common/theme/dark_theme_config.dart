import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/theme/app_colors.dart';

final darkThemeConf = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    brightness: Brightness.dark,
  ),
  extensions: [darkCustomColors]
);


AppColors darkCustomColors = const AppColors(customColor1: Colors.white, customColor2: Colors.black);
