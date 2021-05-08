import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/stores_service.dart';
import 'store_add_edit_controller.dart';
import 'store_add_edit_page.dart';

class StoreAddEditModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoresService(i())),
        Bind((i) => StoreAddEditController(i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => StoreAddEditPage(storeId: args?.data != null ? args?.data['storeId'] : null)),
      ];

  static Inject get to => Inject<StoreAddEditModule>.of();
}
