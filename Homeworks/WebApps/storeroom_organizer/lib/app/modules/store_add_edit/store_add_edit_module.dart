import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/product_service.dart';
import '../../shared/services/store_items_service.dart';
import 'store_add_edit_controller.dart';
import 'store_add_edit_page.dart';

class StoreAddEditModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoreItemsService(i())),
        Bind((i) => ProductService(i())),
        Bind((i) => StoreAddEditController(i(), i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => StoreAddEditPage(storeId: args?.data != null ? args?.data['storeId'] : null)),
      ];

  static Inject get to => Inject<StoreAddEditModule>.of();
}
