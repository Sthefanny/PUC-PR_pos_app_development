import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/services/stores_service.dart';
import '../../shared/utils/user_utils.dart';

part 'stores_controller.g.dart';

@Injectable()
class StoresController = _StoresControllerBase with _$StoresController;

abstract class _StoresControllerBase with Store {
  final StoresService _service;

  _StoresControllerBase(this._service);

  @observable
  String userName = '';
  @observable
  ObservableList<StoreResponse> storeList;

  @action
  Future<void> setUserName() async {
    final _userData = await UserUtils.getUserData();
    userName = _userData.name;
  }

  Future<void> getStores() async {
    try {
      await _service.listAllStores().then((result) {
        if (result != null) {
          storeList = ObservableList<StoreResponse>()
            ..clear()
            ..addAll(result);
        }
      });
    } catch (e) {
      storeList = ObservableList<StoreResponse>()
        ..clear()
        ..addAll(ObservableList<StoreResponse>());
      rethrow;
    }
  }

  Future<bool> deleteItem(int storeId) async {
    bool response;

    await _service.deleteStore(storeId).then((result) {
      response = result;
    }).catchError((error) async {
      return DioConfig.handleError(error, deleteItem);
    });

    return response;
  }
}
