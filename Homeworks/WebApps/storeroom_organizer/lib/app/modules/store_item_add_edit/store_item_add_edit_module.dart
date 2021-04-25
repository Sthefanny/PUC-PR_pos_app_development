import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/product_service.dart';
import '../../shared/services/store_items_service.dart';
import 'store_item_add_edit_controller.dart';
import 'store_item_add_edit_page.dart';

class StoreItemAddEditModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoreItemsService(i())),
        Bind((i) => ProductService(i())),
        Bind((i) => StoreItemAddEditController(i(), i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => StoreItemAddEditPage(storeId: args?.data != null ? args?.data['storeId'] : null, id: args?.data != null ? args?.data['id'] : null)),
      ];

  static Inject get to => Inject<StoreItemAddEditModule>.of();
}
