import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/repositories/secure_storage_repository.dart';
import '../../shared/services/store_service.dart';
import '../../shared/utils/user_utils.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final StoreService _service;

  _HomeControllerBase(this._service);

  @observable
  String userName = '';
  @observable
  ObservableList<StoreResponse> storeList;

  @action
  Future<void> setUserName() async {
    final _userData = await UserUtils.getUserData();
    userName = _userData.name;
  }

  Future<void> getStoreItems() async {
    try {
      List<StoreResponse> response;

      await _service.listAllItemsFromStore().then((result) => response = result).catchError(DioConfig.handleError);

      if (response != null) {
        storeList = ObservableList<StoreResponse>()
          ..clear()
          ..addAll(response);
      }
    } catch (e) {
      throw Exception(e.toString());
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
