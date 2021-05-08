import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/services/user_service.dart';
import 'my_account_controller.dart';
import 'my_account_page.dart';
import 'update_password/update_password_controller.dart';
import 'update_password/update_password_page.dart';
import 'update_user/update_user_controller.dart';
import 'update_user/update_user_page.dart';

class MyAccountModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => UserService(i())),
        $MyAccountController,
        $UpdateUserController,
        $UpdatePasswordController,
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => const MyAccountPage()),
        ModularRouter('/updateUser', child: (_, args) => const UpdateUserPage()),
        ModularRouter('/updatePassword', child: (_, args) => const UpdatePasswordPage()),
      ];

  static Inject get to => Inject<MyAccountModule>.of();
}
