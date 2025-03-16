import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/theme/dark_theme_config.dart';
import 'package:flutter_starter_template/common/theme/light_theme_config.dart';

class ThemeProvider {
  ThemeData get lightTheme => lightThemeConf;
  ThemeData get darkTheme => darkThemeConf;
}
