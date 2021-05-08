import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/requests/store_request.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/services/stores_service.dart';

part 'stores_controller.g.dart';

@Injectable()
class StoresController = _StoresControllerBase with _$StoresController;

abstract class _StoresControllerBase with Store {
  final StoresService _service;

  _StoresControllerBase(this._service);

  @observable
  String newStoreName = '';
  @observable
  String newStoreDescription = '';
  @action
  String changeNewStoreName(String value) => newStoreName = value;
  @action
  String changeNewStoreDescription(String value) => newStoreDescription = value;

  @computed
  bool get canAddNewStore => newStoreName != null && newStoreName.isNotEmpty;

  Future<List<StoreResponse>> getStores() async {
    final response = <StoreResponse>[];
    try {
      await _service.listAllStores().then((result) {
        if (result != null) {
          response
            ..clear()
            ..addAll(result);
        }
      });
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future<bool> createStore() async {
    bool response = false;

    try {
      final request = StoreRequest(name: newStoreName, description: newStoreDescription);

      await _service.createStore(request).then((result) {
        response = result != null && result.id != null;
      });
    } catch (e) {
      rethrow;
    }
    return response;
  }

  Future<bool> deleteStore(int storeId) async {
    bool response;

    try {
      await _service.deleteStore(storeId).then((result) => response = result);
    } catch (e) {
      rethrow;
    }

    return response;
  }
}
