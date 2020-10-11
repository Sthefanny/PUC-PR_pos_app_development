import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_widget.dart';
import 'modules/home/home_module.dart';
import 'modules/loading/loading_controller.dart';
import 'modules/login/login_module.dart';
import 'modules/splash/splash_module.dart';
import 'shared/configs/dio_config.dart';
import 'shared/repositories/secure_storage_repository.dart';
import 'shared/rest_client.dart';
import 'shared/services/auth_service.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => Dio(), singleton: true),
        Bind((i) => FlutterSecureStorage(), singleton: true),
        Bind((i) => SecureStorageRepository(i()), singleton: true),
        Bind((i) => DioConfig(i(), i()), singleton: true),
        Bind((i) => RestClient(i()), singleton: true),
        Bind((i) => AuthService(i(), i(), i()), singleton: true),
        Bind((i) => LoadingController(), singleton: true),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: SplashModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/home', module: HomeModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
