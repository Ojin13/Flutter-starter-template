import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/theme/app_colors.dart';

final lightThemeConf = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
    ),
    extensions: [lightCustomColors]
);


AppColors lightCustomColors = const AppColors(customColor1: Colors.white, customColor2: Colors.black);
