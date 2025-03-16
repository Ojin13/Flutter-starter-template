import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_starter_template/common/model/application_settings_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  final _settingsController = BehaviorSubject<ApplicationSettingsModel>.seeded(ApplicationSettingsModel(
    themeMode: SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
  ));
  Stream<ApplicationSettingsModel> get settingsStream => _settingsController.stream;

  SettingsController() {
    setup();
  }
  void setup() async {
    // Initialize the theme mode with the current platform brightness
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool? useDarkMode = sharedPreferences.getBool('useDarkMode');
    if (useDarkMode == null) {
      if (kDebugMode) {
        print('useDarkMode is null');
      }
      ThemeMode systemTheme = getSystemThemeMode();
      useDarkMode = systemTheme == ThemeMode.dark;
      sharedPreferences.setBool('useDarkMode', useDarkMode);
    }

    updateThemeMode(useDarkMode ? ThemeMode.dark : ThemeMode.light);
    sharedPreferences.setBool('useDarkMode', useDarkMode);
  }

  void updateThemeMode(ThemeMode themeMode) => _updateSettings(themeMode: themeMode);

  void _updateSettings({ThemeMode? themeMode}) {
    final currentSettings = _settingsController.value;
    final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
    _settingsController.add(updatedSettings);

    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setBool('useDarkMode', themeMode == ThemeMode.dark);
    });
  }

  void getSharedPref() async {
    SharedPreferences.getInstance().then((sharedPreferences) {
      if (kDebugMode) {
        print('Dark mode: ${sharedPreferences.getBool('useDarkMode')}');
      }
    });
  }

  ThemeMode getSystemThemeMode() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
