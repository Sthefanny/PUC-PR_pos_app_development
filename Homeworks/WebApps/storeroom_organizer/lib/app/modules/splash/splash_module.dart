import 'package:flutter_modular/flutter_modular.dart';

import 'splash_controller.dart';
import 'splash_page.dart';

class SplashModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => SplashController(i(), i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => const SplashPage(), transition: TransitionType.downToUp),
      ];

  static Inject get to => Inject<SplashModule>.of();
}
