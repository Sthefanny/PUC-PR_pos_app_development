import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_widget.dart';
import 'modules/loading/loading_controller.dart';
import 'modules/login/login_module.dart';
import 'modules/my_account/my_account_module.dart';
import 'modules/splash/splash_module.dart';
import 'modules/store_add_edit/store_add_edit_module.dart';
import 'modules/store_item_add_edit/store_item_add_edit_module.dart';
import 'modules/store_items/store_items_module.dart';
import 'modules/stores/stores_module.dart';
import 'shared/configs/auth_config.dart';
import 'shared/configs/dio_config.dart';
import 'shared/repositories/secure_storage_repository.dart';
import 'shared/rest_client.dart';
import 'shared/services/auth_service.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => Dio()),
        Bind((i) => const FlutterSecureStorage()),
        Bind((i) => SecureStorageRepository(i())),
        Bind((i) => DioConfig()),
        Bind((i) => AuthConfig(i(), i())),
        Bind((i) => RestClient(i())),
        Bind((i) => AuthService(i(), i(), i())),
        Bind((i) => LoadingController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: SplashModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/stores', module: StoresModule()),
        ModularRouter('/storeItems', module: StoreItemsModule()),
        ModularRouter('/storeAddEdit', module: StoreAddEditModule()),
        ModularRouter('/storeItemAddEdit', module: StoreItemAddEditModule()),
        ModularRouter('/myAccount', module: MyAccountModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
