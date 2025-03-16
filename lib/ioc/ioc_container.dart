import 'package:get_it/get_it.dart';
import 'package:flutter_starter_template/service/image_data_service.dart';
import 'package:flutter_starter_template/service/settings_controller.dart';
import 'package:flutter_starter_template/service/user_service.dart';

import '../common/theme/theme_provider.dart';
import '../service/firebase/firebase_auth_service.dart';

final get = GetIt.instance;

class IocContainer {
  IocContainer._();

  static void setup() {
    get.registerSingleton(SettingsController());
    get.registerSingleton(ThemeProvider());
    get.registerSingleton(UserService());
    get.registerSingleton(FirebaseAuthService());
    get.registerSingleton(ImageDataService());
  }
}
