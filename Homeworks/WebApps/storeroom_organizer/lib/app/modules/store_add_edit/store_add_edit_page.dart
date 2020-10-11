import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../shared/widgets/dropdown_button_default.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/product_response.dart';
import '../../shared/models/unit_mea_model.dart';
import '../../shared/widgets/text_field_default.dart';
import '../loading/loading_widget.dart';
import 'store_add_edit_controller.dart';

class StoreAddEditPage extends StatefulWidget {
  final String title;
  const StoreAddEditPage({Key key, this.title = "StoreAddEdit"}) : super(key: key);

  @override
  _StoreAddEditPageState createState() => _StoreAddEditPageState();
}

class _StoreAddEditPageState extends ModularState<StoreAddEditPage, StoreAddEditController> {
  Size _size;
  var _quantityEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.listAllProducts();
    controller.listAllUnitMea();
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
            child: SvgPicture.asset(
              'assets/images/add_item.svg',
              height: 100,
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
          _buildMiniButton(
              icon: FontAwesomeIcons.minus,
              onTap: () {
                controller.decreaseQuantity();
                _quantityEditingController.text = controller.quantity.toString();
              }),
          _buildQuantityField(),
          _buildMiniButton(
              icon: FontAwesomeIcons.plus,
              onTap: () {
                controller.increaseQuantity();
                _quantityEditingController.text = controller.quantity.toString();
              }),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Observer(builder: (_) {
          return TextFieldWidget(
            initialValue: controller.quantity.toString(),
            cursorColor: ColorsConfig.purpleDark,
            hintText: 'Quantidade',
            onChanged: (value) => controller.changeQuantity(int.parse(value)),
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {},
            textEditingController: _quantityEditingController,
          );
        }),
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
          child: _buildMiniButton(icon: FontAwesomeIcons.camera, onTap: () {}),
        ),
        _buildMiniButton(icon: FontAwesomeIcons.fileImage, onTap: () {}),
      ],
    );
  }

  Widget _buildButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: EdgeInsets.only(top: 10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: ColorsConfig.button,
          disabledColor: ColorsConfig.disabledButton,
          textColor: Colors.white,
          disabledTextColor: Colors.grey,
          child: Text(
            'Criar'.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
