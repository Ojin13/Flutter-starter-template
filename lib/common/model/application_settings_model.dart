import 'package:flutter/material.dart';

class ApplicationSettingsModel {
  final ThemeMode themeMode;

  ApplicationSettingsModel({
    this.themeMode = ThemeMode.light,
  });

  ApplicationSettingsModel copyWith({ThemeMode? themeMode}) {
    return ApplicationSettingsModel(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
