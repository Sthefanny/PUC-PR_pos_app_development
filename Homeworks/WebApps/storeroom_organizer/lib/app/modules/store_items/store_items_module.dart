import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/store_items_service.dart';
import 'store_items_controller.dart';
import 'store_items_page.dart';

class StoreItemsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoreItemsService(i())),
        Bind((i) => StoreItemsController(i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => const StoreItemsPage()),
      ];

  static Inject get to => Inject<StoreItemsModule>.of();
}
