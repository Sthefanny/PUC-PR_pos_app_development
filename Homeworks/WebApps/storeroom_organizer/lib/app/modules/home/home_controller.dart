import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/enums/config_enum.dart';
import '../../shared/repositories/secure_storage_repository.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final SecureStorageRepository _secureStorageService;

  _HomeControllerBase(this._secureStorageService);

  @observable
  String userName = '';

  @action
  Future<void> setUserName() async {
    userName = await _secureStorageService.getItem(ConfigurationEnum.userName.toStr);
  }
}
