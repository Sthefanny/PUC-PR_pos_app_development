import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/responses/store_item_response.dart';
import '../../shared/services/store_items_service.dart';

part 'store_items_controller.g.dart';

@Injectable()
class StoreItemsController = _StoreItemsControllerBase with _$StoreItemsController;

abstract class _StoreItemsControllerBase with Store {
  final StoreItemsService _service;

  _StoreItemsControllerBase(this._service);

  @observable
  String userName = '';
  @observable
  ObservableList<StoreItemResponse> storeList;

  Future<void> getStoreItems(int storeId) async {
    try {
      await _service.listAllItemsFromStore(storeId).then((result) {
        if (result != null) {
          storeList = ObservableList<StoreItemResponse>()
            ..clear()
            ..addAll(result);
        }
      });
    } catch (e) {
      storeList = ObservableList<StoreItemResponse>()
        ..clear()
        ..addAll(ObservableList<StoreItemResponse>());
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

  Future<bool> deleteItem({int storeId, int id}) async {
    try {
      bool response;

      await _service.deleteItemFromStore(storeId: storeId, id: id).then((result) {
        response = result;
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
