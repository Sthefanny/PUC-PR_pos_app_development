import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/product_service.dart';
import '../../shared/services/store_service.dart';
import 'store_add_edit_controller.dart';
import 'store_add_edit_page.dart';

class StoreAddEditModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoreService(i()), singleton: true),
        Bind((i) => ProductService(i()), singleton: true),
        Bind((i) => StoreAddEditController(i(), i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => StoreAddEditPage()),
      ];

  static Inject get to => Inject<StoreAddEditModule>.of();
}
