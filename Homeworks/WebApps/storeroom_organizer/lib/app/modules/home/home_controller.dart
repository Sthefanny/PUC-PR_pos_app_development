import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/enums/config_enum.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/repositories/secure_storage_repository.dart';
import '../../shared/services/store_service.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final StoreService _service;
  final SecureStorageRepository _secureStorageService;

  _HomeControllerBase(this._service, this._secureStorageService);

  @observable
  String userName = '';

  @action
  Future<void> setUserName() async {
    userName = await _secureStorageService.getItem(ConfigurationEnum.userName.toStr);
  }

  Future<List<StoreResponse>> getStoreItems() async {
    try {
      return await _service.listAllItemsFromStore();
    } catch (e) {
      throw e.toString();
    }
  }
}
