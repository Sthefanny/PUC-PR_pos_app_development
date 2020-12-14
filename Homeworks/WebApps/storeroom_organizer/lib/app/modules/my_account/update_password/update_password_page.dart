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
import 'update_password_controller.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String title;
  final int storeId;
  const UpdatePasswordPage({Key key, this.title = 'StoreAddEdit', this.storeId}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ModularState<UpdatePasswordPage, UpdatePasswordController> {
  final LoadingController _loadingController = Modular.get();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _focusNewPassword = FocusNode();
  Size _size;

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
                _buildTitle(),
                _buildBody(),
                _buildButton(),
              ],
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
            'Alterar senha',
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.purpleDark,
        hintText: 'Senha atual',
        onChanged: controller.changeOldPassword,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textEditingController: _oldPasswordController,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusNewPassword),
      ),
    );
  }

  Widget _buildMinimumShoppingListEditionField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.purpleDark,
        hintText: 'Nova Senha',
        onChanged: controller.changeNewPassword,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        textEditingController: _newPasswordController,
        focusNode: _focusNewPassword,
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
            onPressed: controller.canUpdate ? _updatePassword : null,
            child: Text(
              'Atualizar'.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }

  void _updatePassword() {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.updatePassword().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pop();
        SnackbarMessages.showSuccess(context: context, description: 'Alteração realizada com sucesso!');
      }
    }).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        _loadingController.changeVisibility(false);
        return _updatePassword();
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    }).whenComplete(() {
      _loadingController.changeVisibility(false);
    });
  }
}
