import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/enums/unit_mea_enum.dart';
import '../../shared/models/responses/product_response.dart';
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
  int productSelected;
  @observable
  String productName;
  @observable
  int unitMeaSelected;
  @observable
  int quantity = 0;
  @observable
  bool productNameIsVisible = false;

  @action
  changeProductSelected(int value) => productSelected = value;
  @action
  changeProductName(String value) => productName = value;
  @action
  changeUnitMeaSelected(int value) => unitMeaSelected = value;
  @action
  changeQuantity(int value) => quantity = value;
  @action
  increaseQuantity() => quantity = quantity + 1;
  @action
  decreaseQuantity() {
    if (quantity > 0) quantity = quantity - 1;
  }

  @action
  changeProductNameIsVisible(bool value) => productNameIsVisible = value;

  @action
  Future<void> listAllProducts() async {
    try {
      var response = await _productService.listAllProducts();
      productList.addAll(response);
    } catch (e) {
      throw e.toString();
    }
  }

  @action
  Future<void> listAllUnitMea() async {
    try {
      unitMeaList.add(UnitMeaModel(id: 0, name: unitMeaEnumToStr(UnitMeaEnum.unit)));
      unitMeaList.add(UnitMeaModel(id: 1, name: unitMeaEnumToStr(UnitMeaEnum.weight)));
    } catch (e) {
      throw e.toString();
    }
  }
}
