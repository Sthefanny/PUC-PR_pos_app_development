import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/helpers/snackbar_messages_helper.dart';
import '../../../shared/widgets/text_field_default.dart';
import '../../loading/loading_controller.dart';
import '../login_controller.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends ModularState<SignUp, LoginController> {
  final LoadingController _loadingController = Modular.get();
  final _focusName = FocusNode();
  final _focusLogin = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPass = FocusNode();
  final _nameController = TextEditingController();
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 23),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 300,
                  height: 320,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: <Widget>[
                      nameField(),
                      loginField(),
                      passwordField(),
                      confirmPassField(),
                    ],
                  ),
                ),
              ),
              buildSubmitButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget nameField() {
    return TextFieldWidget(
      cursorColor: ColorsConfig.purpleDark,
      hintText: 'Nome',
      onChanged: controller.changeSignupName,
      keyboardType: TextInputType.text,
      focusNode: _focusName,
      textEditingController: _nameController,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_focusLogin),
    );
  }

  Widget loginField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.purpleDark,
        hintText: 'Email',
        onChanged: controller.changeSignupLogin,
        keyboardType: TextInputType.text,
        focusNode: _focusLogin,
        textEditingController: _loginController,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
      ),
    );
  }

  Widget passwordField() {
    return Observer(
      builder: (_) {
        return TextFieldWidget(
          cursorColor: ColorsConfig.purpleDark,
          hintText: 'Senha',
          obscureText: controller.signupObscurePass,
          suffixIcon: IconButton(
            icon: FaIcon(controller.signupObscurePass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 18, color: ColorsConfig.textColor),
            onPressed: controller.toggleSignupObscurePass,
          ),
          onChanged: controller.changeSignupPass,
          keyboardType: TextInputType.text,
          focusNode: _focusPassword,
          textEditingController: _passController,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(_focusConfirmPass),
        );
      },
    );
  }

  Widget confirmPassField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Observer(
        builder: (_) {
          return TextFieldWidget(
            cursorColor: ColorsConfig.purpleDark,
            hintText: 'Confirmação de senha',
            obscureText: controller.signupObscureConfirmPass,
            suffixIcon: IconButton(
              icon: FaIcon(controller.signupObscureConfirmPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 18, color: ColorsConfig.textColor),
              onPressed: controller.toggleSignupObscureConfirmPass,
            ),
            onChanged: controller.changeSignupConfirmPass,
            keyboardType: TextInputType.text,
            focusNode: _focusConfirmPass,
            textEditingController: _confirmPassController,
            textInputAction: TextInputAction.done,
            onEditingComplete: controller.canSignUp ? _signUp : null,
          );
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: const EdgeInsets.only(top: 295),
        child: Observer(builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: ColorsConfig.button,
            disabledColor: ColorsConfig.disabledButton,
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            onPressed: controller.canSignUp ? _signUp : null,
            child: Text(
              'Criar'.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }

  void _signUp() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!controller.isPassEqual) {
      SnackbarMessages.showInfo(context: context, description: 'Senha e confirmação devem ser iguais');
      return;
    }

    _loadingController.changeVisibility(true);

    controller.submitSignUp().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        SnackbarMessages.showSuccess(context: context, description: 'Usuário criado com sucesso!');
        _clearAllFields();
        controller.changePageController(0);
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }

  void _clearAllFields() {
    _nameController.clear();
    _loginController.clear();
    _passController.clear();
    _confirmPassController.clear();
    controller
      ..changeSignupName('')
      ..changeSignupLogin('')
      ..changeSignupPass('')
      ..changeSignupConfirmPass('');
  }
}
