import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/product_response.dart';
import '../../shared/models/unit_mea_model.dart';
import '../../shared/utils/permission_utils.dart';
import '../../shared/widgets/dropdown_button_default.dart';
import '../../shared/widgets/text_field_default.dart';
import '../loading/loading_controller.dart';
import '../loading/loading_widget.dart';
import 'store_add_edit_controller.dart';
import '../../shared/extensions/string_extensions.dart';

class StoreAddEditPage extends StatefulWidget {
  final String title;
  final int storeId;
  const StoreAddEditPage({Key key, this.title = "StoreAddEdit", this.storeId}) : super(key: key);

  @override
  _StoreAddEditPageState createState() => _StoreAddEditPageState();
}

class _StoreAddEditPageState extends ModularState<StoreAddEditPage, StoreAddEditController> {
  final LoadingController _loadingController = Modular.get();
  var _quantityEditingController = TextEditingController();
  ReactionDisposer _disposer;
  Size _size;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _validateQuantityText();
    controller.changeId(widget.storeId);
    controller.init();
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  void _validateQuantityText() {
    _disposer = reaction(
      (_) => controller.quantity,
      (quantity) {
        _quantityEditingController.text = quantity.toString();
        _quantityEditingController.selection = TextSelection.fromPosition(TextPosition(offset: quantity.toString().length));
      },
    );
  }

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null) {
      controller.changeImagePicked(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: Container(
            decoration: VisualIdentityHelper.buildBackground(),
            child: ListView(
              children: [
                _buildHeader(),
                _buildBody(),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        children: [
          _buildTitle(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Observer(
              builder: (_) {
                return controller.imagePicked != null
                    ? Image.file(controller.imagePicked, height: 200)
                    : controller.imageUrl != null
                        ? Image.network(controller.imageUrl, height: 200)
                        : SvgPicture.asset(
                            'assets/images/add_item.svg',
                            height: 200,
                          );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => Modular.to.pop(),
              color: Colors.white,
            ),
          ),
          Text(
            'Adicionar item na dispensa',
            style: themeData.textTheme.headline5.merge(TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          _buildProductFields(),
          _buildProductNameField(),
          _buildUnitMeaSelect(),
          _buildQuantityFields(),
          _buildImageField(),
        ],
      ),
    );
  }

  Widget _buildProductFields() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildProductSelect(),
          _buildMiniButton(icon: FontAwesomeIcons.plus, onTap: () => controller.changeProductNameIsVisible(true)),
        ],
      ),
    );
  }

  Widget _buildProductSelect() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Observer(
          builder: (_) {
            if (controller.productList == null || controller.productList.isEmpty) return const SizedBox();

            return DropdownButtonWidget<int>(
              value: controller.productSelected,
              hintText: 'Selecionar produto',
              onChanged: controller.changeProductSelected,
              items: controller.productList.map<DropdownMenuItem<int>>(
                (ProductResponse product) {
                  return DropdownMenuItem<int>(
                    value: product.id,
                    child: Text(product.name),
                  );
                },
              ).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductNameField() {
    return Observer(builder: (_) {
      return Visibility(
        visible: controller.productNameIsVisible,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextFieldWidget(
            cursorColor: ColorsConfig.purpleDark,
            hintText: 'Nome do produto',
            onChanged: controller.changeProductName,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        ),
      );
    });
  }

  Widget _buildUnitMeaSelect() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Observer(
        builder: (_) {
          if (controller.unitMeaList == null || controller.unitMeaList.isEmpty) return const SizedBox();

          return DropdownButtonWidget<int>(
            value: controller.unitMeaSelected,
            hintText: 'Selecionar unidade de medida',
            onChanged: controller.changeUnitMeaSelected,
            items: controller.unitMeaList.map<DropdownMenuItem<int>>(
              (UnitMeaModel unitMea) {
                return DropdownMenuItem<int>(
                  value: unitMea.id,
                  child: Text(unitMea.name, style: themeData.textTheme.bodyText1),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }

  Widget _buildQuantityFields() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildMiniButton(icon: FontAwesomeIcons.minus, onTap: decreaseQuantity),
          _buildQuantityField(),
          _buildMiniButton(icon: FontAwesomeIcons.plus, onTap: increaseQuantity),
        ],
      ),
    );
  }

  void increaseQuantity() {
    var _quantity = _quantityEditingController.text.isNullOrEmpty() ? 0 : int.parse(_quantityEditingController.text);
    _quantityEditingController.text = (_quantity + 1).toString();
  }

  void decreaseQuantity() {
    var _quantity = _quantityEditingController.text.isNullOrEmpty() ? 0 : int.parse(_quantityEditingController.text);
    if (_quantity > 0) {
      _quantityEditingController.text = (_quantity - 1).toString();
    }
  }

  Widget _buildQuantityField() {
    _quantityEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _quantityEditingController.text.length));

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: TextFieldWidget(
          cursorColor: ColorsConfig.purpleDark,
          hintText: 'Quantidade',
          onChanged: (value) {},
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
          textEditingController: _quantityEditingController,
        ),
      ),
    );
  }

  Widget _buildMiniButton({@required IconData icon, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: ColorsConfig.button,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: FaIcon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildImageField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Adicionar imagem:',
          style: themeData.textTheme.headline6.merge(TextStyle(color: Colors.white)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildMiniButton(
            icon: FontAwesomeIcons.camera,
            onTap: () async {
              if (await PermissionUtils.checkCameraPermission()) {
                getImage(ImageSource.camera);
              } else {
                PermissionUtils.showPermissionError(context);
              }
            },
          ),
        ),
        _buildMiniButton(
          icon: FontAwesomeIcons.fileImage,
          onTap: () async {
            if (await PermissionUtils.checkStoragePermission()) {
              getImage(ImageSource.gallery);
            } else {
              PermissionUtils.showPermissionError(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: EdgeInsets.only(top: 10, bottom: 20),
        child: Observer(builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: ColorsConfig.button,
            disabledColor: ColorsConfig.disabledButton,
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            child: Text(
              widget.storeId != null ? 'Atualizar'.toUpperCase() : 'Criar'.toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: controller.canAddEditStore
                ? widget.storeId != null
                    ? _editItemFromStore
                    : _addItemToStore
                : null,
          );
        }),
      ),
    );
  }

  void _addItemToStore() {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.changeQuantity(int.parse(_quantityEditingController.text));

    controller.addItemToStore().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pop();
        SnackbarMessages.showSuccess(context: context, description: 'Produto incluído na dispensa com sucesso!');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }

  void _editItemFromStore() {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.changeQuantity(int.parse(_quantityEditingController.text));

    controller.editItemFromStore().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pop();
        SnackbarMessages.showSuccess(context: context, description: 'Produto atualizado com sucesso!');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
