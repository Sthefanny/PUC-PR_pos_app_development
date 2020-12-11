import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/configs/urls_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/responses/product_response.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/models/unit_mea_model.dart';
import '../../shared/services/product_service.dart';
import '../../shared/services/store_service.dart';

part 'store_add_edit_controller.g.dart';

@Injectable()
class StoreAddEditController = _StoreAddEditControllerBase with _$StoreAddEditController;

abstract class _StoreAddEditControllerBase with Store {
  final StoreService _storeService;
  final ProductService _productService;

  _StoreAddEditControllerBase(this._storeService, this._productService);

  @observable
  List<ProductResponse> productList = ObservableList<ProductResponse>();
  @observable
  List<UnitMeaModel> unitMeaList = ObservableList<UnitMeaModel>();
  @observable
  int storeId;
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

  @action
  int changeId(int value) => storeId = value;
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
    if (storeId != null) await getStoreItemInfo();
  }

  @action
  Future<void> listAllProducts() async {
    await _productService.listAllProducts().then((result) {
      if (result != null) {
        productList
          ..clear()
          ..addAll(result);
      }
    }).catchError((error) async {
      return DioConfig.handleError(error, listAllProducts);
    });
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

  Future<bool> addItemToStore() async {
    if (canAddEditStore) {
      final request = StoreResponse(unitMea: unitMeaSelected, product: productName, productId: productSelected, quantity: quantity.toDouble());
      StoreResponse response;

      await _storeService.addItemToStore(request).then((result) {
        response = result;
      }).catchError((error) async {
        return DioConfig.handleError(error, addItemToStore);
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
  }

  Future<bool> addImageToStoreItem(int storeId) async {
    if (storeId != null && imagePicked != null) {
      StoreResponse response;

      await _storeService.addImageToItem(storeId, imagePicked).then((result) {
        response = result;
      }).catchError((error) async {
        return DioConfig.handleError(error, () => addImageToStoreItem(storeId));
      });

      if (response != null && response.imageUrl != null) {
        return true;
      }

      return false;
    }
    return false;
  }

  Future<void> getStoreItemInfo() async {
    await _storeService.getItemFromStore(storeId).then((result) {
      if (result != null && result.id != null) {
        changeProductSelected(result.productId);
        changeUnitMeaSelected(result.unitMea);
        changeQuantity(result.quantity.toInt());
        if (result.imageUrl.isNotNullOrEmpty()) changeImageUrl('${UrlConfig.baseUrl}${result.imageUrl}');
        return;
      }
    }).catchError((error) async {
      return DioConfig.handleError(error, listAllProducts);
    });
  }

  Future<bool> editItemFromStore() async {
    bool response = false;

    if (canAddEditStore) {
      final request = StoreResponse(id: storeId, unitMea: unitMeaSelected, product: productName, productId: productSelected, quantity: quantity.toDouble());

      await _storeService.editItemToStore(request).then((result) async {
        if (result != null && result.id != null) {
          if (imagePicked != null) {
            final imageResponse = await addImageToStoreItem(result.id);
            response = imageResponse;
          }
          response = true;
        }

        response = false;
      }).catchError((error) async {
        return DioConfig.handleError(error, listAllProducts);
      });
    }
    return response;
  }
}
