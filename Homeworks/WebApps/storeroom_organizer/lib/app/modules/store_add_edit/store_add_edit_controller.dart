import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/requests/store_request.dart';
import '../../shared/models/responses/product_response.dart';
import '../../shared/models/unit_mea_model.dart';
import '../../shared/services/product_service.dart';
import '../../shared/services/store_items_service.dart';
import '../../shared/services/stores_service.dart';

part 'store_add_edit_controller.g.dart';

@Injectable()
class StoreAddEditController = _StoreAddEditControllerBase with _$StoreAddEditController;

abstract class _StoreAddEditControllerBase with Store {
  final StoresService _service;

  _StoreAddEditControllerBase(this._service);

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
}
