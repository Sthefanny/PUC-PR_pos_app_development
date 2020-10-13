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
  changeId(int value) => storeId = value;
  @action
  changeProductSelected(int value) => productSelected = value;
  @action
  changeProductName(String value) => productName = value;
  @action
  changeUnitMeaSelected(int value) => unitMeaSelected = value;
  @action
  changeQuantity(int value) => quantity = value;
  @action
  changeImageUrl(String value) => imageUrl = value;
  @action
  increaseQuantity() => quantity = quantity + 1;
  @action
  decreaseQuantity() {
    if (quantity > 0) quantity = quantity - 1;
  }

  @action
  changeProductNameIsVisible(bool value) => productNameIsVisible = value;
  @action
  changeImagePicked(File value) => imagePicked = value;

  @computed
  bool get hasProduct => productSelected != null && productSelected >= 0 || productName.isNotNullOrEmpty();

  @computed
  bool get canAddEditStore => hasProduct && unitMeaSelected != null && unitMeaSelected >= 0;

  Future<void> init() async {
    await listAllProducts();
    await listAllUnitMea();
    if (storeId != null) getStoreItemInfo();
  }

  @action
  Future<void> listAllProducts() async {
    try {
      var response = await _productService.listAllProducts();
      productList.clear();
      productList.addAll(response);
    } catch (e) {
      throw e.toString();
    }
  }

  @action
  Future<void> listAllUnitMea() async {
    try {
      unitMeaList.clear();
      unitMeaList.add(UnitMeaModel(id: 0, name: unitMeaEnumToStr(UnitMeaEnum.unit)));
      unitMeaList.add(UnitMeaModel(id: 1, name: unitMeaEnumToStr(UnitMeaEnum.weight)));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> addItemToStore() async {
    if (canAddEditStore) {
      var request = StoreResponse(unitMea: unitMeaSelected, product: productName, productId: productSelected, quantity: quantity.toDouble());
      StoreResponse response;

      await _storeService.addItemToStore(request).then((result) => response = result).catchError(DioConfig.handleError);

      if (response != null && response.id != null) {
        if (imagePicked != null) {
          var imageResponse = await addImageToStoreItem(response.id);
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

      await _storeService.addImageToItem(storeId, imagePicked).then((result) => response = result).catchError(DioConfig.handleError);

      if (response != null && response.imageUrl != null) {
        return true;
      }

      return false;
    }
    return false;
  }

  Future<void> getStoreItemInfo() async {
    StoreResponse response;

    await _storeService.getItemFromStore(storeId).then((result) => response = result).catchError(DioConfig.handleError);

    if (response != null && response.id != null) {
      changeProductSelected(response.productId);
      changeUnitMeaSelected(response.unitMea);
      changeQuantity(response.quantity.toInt());
      if (response.imageUrl.isNotNullOrEmpty()) changeImageUrl('${UrlConfig.baseUrl}${response.imageUrl}');
      return;
    }

    throw Exception('Ocorreu um erro ao tentar carregar os dados.');
  }

  Future<bool> editItemFromStore() async {
    if (canAddEditStore) {
      var request = StoreResponse(id: storeId, unitMea: unitMeaSelected, product: productName, productId: productSelected, quantity: quantity.toDouble());
      StoreResponse response;

      await _storeService.editItemToStore(request).then((result) => response = result).catchError(DioConfig.handleError);

      if (response != null && response.id != null) {
        if (imagePicked != null) {
          var imageResponse = await addImageToStoreItem(response.id);
          return imageResponse;
        }
        return true;
      }

      return false;
    }
    return false;
  }
}
