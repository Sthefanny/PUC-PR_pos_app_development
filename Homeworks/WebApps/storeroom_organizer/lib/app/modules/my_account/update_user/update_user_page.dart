import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/configs/dio_config.dart';
import '../../../shared/configs/themes_config.dart';
import '../../../shared/helpers/snackbar_messages_helper.dart';
import '../../../shared/helpers/visual_identity_helper.dart';
import '../../../shared/widgets/text_field_default.dart';
import '../../loading/loading_controller.dart';
import '../../loading/loading_widget.dart';
import 'update_user_controller.dart';

class UpdateUserPage extends StatefulWidget {
  final String title;
  final int storeId;
  const UpdateUserPage({Key key, this.title = 'StoreAddEdit', this.storeId}) : super(key: key);

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends ModularState<UpdateUserPage, UpdateUserController> {
  final LoadingController _loadingController = Modular.get();
  final _daysToExpireController = TextEditingController();
  final _minimumShoppingListController = TextEditingController();
  final _focusMinimumShoppingList = FocusNode();
  Size _size;

  @override
  void initState() {
    super.initState();
    controller.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: SafeArea(
            child: Container(
              decoration: VisualIdentityHelper.buildBackground(),
              child: ListView(
                children: [
                  _buildTitle(),
                  _buildBody(),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => Modular.to.pop(),
              color: Colors.white,
            ),
          ),
          Text(
            'Alterar dados da conta',
            style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white)),
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
          _buildDaysToExpireEditionField(),
          _buildMinimumShoppingListEditionField(),
        ],
      ),
    );
  }

  Widget _buildDaysToExpireEditionField() {
    const title = 'Alerta de expiração';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white))),
          ),
          Observer(builder: (_) {
            _daysToExpireController
              ..text = controller.daysToExpire
              ..selection = TextSelection.fromPosition(TextPosition(offset: _daysToExpireController.text.length));

            return TextFieldWidget(
              cursorColor: ColorsConfig.purpleDark,
              hintText: title,
              onChanged: controller.changeDaysToExpire,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textEditingController: _daysToExpireController,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_focusMinimumShoppingList),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMinimumShoppingListEditionField() {
    const title = 'Mínimo para lista de compras';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white))),
          ),
          Observer(builder: (_) {
            _minimumShoppingListController
              ..text = controller.minimumShoppingList
              ..selection = TextSelection.fromPosition(TextPosition(offset: _minimumShoppingListController.text.length));

            return TextFieldWidget(
              cursorColor: ColorsConfig.purpleDark,
              hintText: title,
              onChanged: controller.changeMinimumShoppingList,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textEditingController: _minimumShoppingListController,
              focusNode: _focusMinimumShoppingList,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: Observer(builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: ColorsConfig.button,
            disabledColor: ColorsConfig.disabledButton,
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            onPressed: controller.canUpdate ? _updateUser : null,
            child: Text(
              'Atualizar'.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }

  void _updateUser() {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.updateUser().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pop();
        SnackbarMessages.showSuccess(context: context, description: 'Alteração realizada com sucesso!');
      }
    }).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        _loadingController.changeVisibility(false);
        return _updateUser();
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    }).whenComplete(() {
      _loadingController.changeVisibility(false);
    });
  }
}
