import 'package:flutter/material.dart';
import 'package:flutter_starter_template/common/widget/fullscreen_hud.dart';
import 'package:flutter_starter_template/service/firebase/firebase_auth_service.dart';
import 'package:flutter_starter_template/service/settings_controller.dart';

import 'common/theme/theme_provider.dart';
import 'common/widget/template/tabbed_scaffold.dart';
import 'ioc/ioc_container.dart';

class AppRoot extends StatelessWidget {
  AppRoot({super.key});

  static GlobalKey<NavigatorState> navKey = GlobalKey();
  ThemeMode _themeMode = ThemeMode.light;
  final _themeProvider = get<ThemeProvider>();
  final _authProvider = get<FirebaseAuthService>();
  final _settingsController = get<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _settingsController.settingsStream,
      builder: (context, settingsSnapshot) {

        if (settingsSnapshot.hasError || !settingsSnapshot.hasData) {
          return CircularProgressIndicator();
        }

        final settings = settingsSnapshot.data!;
        _themeMode = settings.themeMode;

        return StreamBuilder(
          stream: _authProvider.authStateChanges,
          builder: (context, snapshot) {
            return MaterialApp(
                navigatorKey: AppRoot.navKey,
                title: 'Flutter starter theme',
                theme: _themeProvider.lightTheme,
                darkTheme: _themeProvider.darkTheme,
                themeMode: _themeMode,
                home: FullscreenHud(child: snapshot.hasData ? TabbedScaffold() : TabbedScaffold()));
          },
        );
      },
    );
  }
}
