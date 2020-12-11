import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/responses/store_response.dart';
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
      await _service.listAllItemsFromStore().then((result) {
        if (result != null) {
          storeList = ObservableList<StoreResponse>()
            ..clear()
            ..addAll(result);
        }
      });
    } catch (e) {
      rethrow;
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

    await _service.deleteItemFromStore(storeId).then((result) {
      response = result;
    }).catchError((error) async {
      return DioConfig.handleError(error, deleteItem);
    });

    return response;
  }
}
