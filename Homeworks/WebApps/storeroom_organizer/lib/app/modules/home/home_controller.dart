import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/models/enums/config_enum.dart';
import '../../shared/models/enums/unit_mea_enum.dart';
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
  @observable
  List<StoreResponse> storeList = ObservableList<StoreResponse>();

  @action
  Future<void> setUserName() async {
    userName = await _secureStorageService.getItem(ConfigurationEnum.userName.toStr);
  }

  Future<void> getStoreItems() async {
    try {
      var response = await _service.listAllItemsFromStore();
      storeList.clear();
      storeList.addAll(response);
    } catch (e) {
      throw e.toString();
    }
  }

  String getUnitMeaName(int unitMea) {
    switch (unitMea) {
      case 0:
        return unitMeaEnumToStr(UnitMeaEnum.unit);
        break;
      case 1:
        return unitMeaEnumToStr(UnitMeaEnum.weight);
        break;
      default:
        return '';
    }
  }

  Future<bool> deleteItem(int storeId) async {
    bool response;

    await _service.deleteItemFromStore(storeId).then((result) => response = result).catchError(DioConfig.handleError);

    return response;
  }
}
