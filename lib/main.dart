import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'app_root.dart';
import 'configuration/firebase_options.dart';
import 'ioc/ioc_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  } catch (e) {
    if (kDebugMode) {
      print('Firebase error: $e');
    }
  }

  IocContainer.setup();

  debugPaintSizeEnabled = false;
  runApp(AppRoot());
}
