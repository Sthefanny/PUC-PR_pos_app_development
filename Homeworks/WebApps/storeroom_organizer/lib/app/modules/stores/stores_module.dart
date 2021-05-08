import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/stores_service.dart';
import 'stores_controller.dart';
import 'stores_page.dart';

class StoresModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => StoresService(i())),
        Bind((i) => StoresController(i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => const StoresPage()),
      ];

  static Inject get to => Inject<StoresModule>.of();
}
