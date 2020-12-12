import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/configs/urls_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/requests/store_item_request.dart';
import '../../shared/models/responses/product_response.dart';
import '../../shared/models/responses/store_item_response.dart';
import '../../shared/models/unit_mea_model.dart';
import '../../shared/services/product_service.dart';
import '../../shared/services/store_items_service.dart';

part 'store_item_add_edit_controller.g.dart';

@Injectable()
class StoreItemAddEditController = _StoreItemAddEditControllerBase with _$StoreItemAddEditController;

abstract class _StoreItemAddEditControllerBase with Store {
  final StoreItemsService _storeService;
  final ProductService _productService;

  _StoreItemAddEditControllerBase(this._storeService, this._productService);

  @observable
  List<ProductResponse> productList = ObservableList<ProductResponse>();
  @observable
  List<UnitMeaModel> unitMeaList = ObservableList<UnitMeaModel>();
  @observable
  int storeItemId;
  @observable
  int productSelected;
  @observable
  String productName;
  @observable
  int unitMeaSelected;
  @observable
  int quantity = 0;
  @observable
  String imageUrl;
  @observable
  bool productNameIsVisible = false;
  @observable
  File imagePicked;
  @observable
  String productObservation;
  @observable
  bool productIsRecurrent = false;
  @observable
  DateTime productSelectedDate = DateTime.now();
  @observable
  String productSelectedDateFormatted;

  @action
  int changeStoreItemId(int value) => storeItemId = value;
  @action
  int changeProductSelected(int value) => productSelected = value;
  @action
  String changeProductName(String value) => productName = value;
  @action
  int changeUnitMeaSelected(int value) => unitMeaSelected = value;
  @action
  int changeQuantity(int value) => quantity = value;
  @action
  String changeImageUrl(String value) => imageUrl = value;
  @action
  void increaseQuantity() => quantity = quantity + 1;
  @action
  void decreaseQuantity() {
    if (quantity > 0) quantity = quantity - 1;
  }

  @action
  String changeProductObservation(String value) => productObservation = value;
  @action
  bool changeProductIsRecurrent(bool value) => productIsRecurrent = !value;
  @action
  DateTime changeProductSelectedDate(DateTime value) => productSelectedDate = value;
  @action
  String changeProductSelectedDateFormatted(String value) => productSelectedDateFormatted = value;

  @action
  bool changeProductNameIsVisible(bool value) => productNameIsVisible = value;
  @action
  File changeImagePicked(File value) => imagePicked = value;

  @computed
  bool get hasProduct => productSelected != null && productSelected >= 0 || productName.isNotNullOrEmpty();

  @computed
  bool get canAddEditStore => hasProduct && unitMeaSelected != null && unitMeaSelected >= 0;

  Future<void> init() async {
    await listAllProducts();
    await listAllUnitMea();
    if (storeItemId != null) await getStoreItemInfo();
  }

  Future<void> listAllProducts() async {
    try {
      await _productService.listAllProducts().then((result) {
        if (result != null) {
          productList
            ..clear()
            ..addAll(result);
        }
      }).catchError((error) async {
        final errorHandled = await DioConfig.handleError(error);
        if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
          return listAllProducts();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> listAllUnitMea() async {
    try {
      unitMeaList
        ..clear()
        ..add(UnitMeaModel(id: 0, name: unitMeaEnumToStr(UnitMeaEnum.unit)))
        ..add(UnitMeaModel(id: 1, name: unitMeaEnumToStr(UnitMeaEnum.weight)));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> addItemToStore(int storeId) async {
    try {
      if (canAddEditStore) {
        final request = StoreItemRequest(
          unitMea: unitMeaSelected,
          product: productName,
          productId: productSelected,
          quantity: quantity.toDouble(),
          expirationDate: productSelectedDate.toIso8601String(),
          observation: productObservation,
          recurrent: productIsRecurrent,
          storeId: storeId,
        );
        StoreItemResponse response;

        await _storeService.addItemToStore(request).then((result) {
          response = result;
        });

        if (response != null && response.id != null) {
          if (imagePicked != null) {
            final imageResponse = await addImageToStoreItem(response.id);
            return imageResponse;
          }
          return true;
        }

        return false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addImageToStoreItem(int storeId) async {
    try {
      if (storeId != null && imagePicked != null) {
        StoreItemResponse response;

        await _storeService.addImageToItem(storeId, imagePicked).then((result) {
          response = result;
        });

        if (response != null && response.imageUrl != null) {
          return true;
        }

        return false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getStoreItemInfo() async {
    try {
      await _storeService.getItemFromStore(storeItemId).then(
        (result) {
          if (result != null && result.id != null) {
            changeProductSelected(result.productId);
            changeUnitMeaSelected(result.unitMea);
            changeQuantity(result.quantity.toInt());
            if (result.imageUrl.isNotNullOrEmpty()) changeImageUrl('${UrlConfig.baseUrl}${result.imageUrl}');
            return;
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> editItemFromStore({@required int storeId, @required int id}) async {
    try {
      bool response = false;

      if (canAddEditStore) {
        final request = StoreItemRequest(
          unitMea: unitMeaSelected,
          product: productName,
          productId: productSelected,
          quantity: quantity.toDouble(),
          expirationDate: productSelectedDate.toIso8601String(),
          observation: productObservation,
          recurrent: productIsRecurrent,
          storeId: storeId,
          id: id,
        );

        await _storeService.editItemToStore(request).then((result) async {
          if (result != null && result.id != null) {
            if (imagePicked != null) {
              final imageResponse = await addImageToStoreItem(result.id);
              response = imageResponse;
            }
            response = true;
          }

          response = false;
        });
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
