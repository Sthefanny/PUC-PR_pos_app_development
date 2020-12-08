import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/helpers/snackbar_messages_helper.dart';
import '../../../shared/widgets/text_field_default.dart';
import '../../loading/loading_controller.dart';
import '../login_controller.dart';

class SignIn extends StatefulWidget {
  final BuildContext parentContext;

  const SignIn({Key key, this.parentContext}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends ModularState<SignIn, LoginController> {
  final LoadingController _loadingController = Modular.get();
  final _focusLogin = FocusNode();
  final _focusPassword = FocusNode();
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
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 300,
                  height: 210,
                  child: Column(
                    children: <Widget>[
                      loginField(),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      passwordField(),
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

  Widget loginField() {
    return TextFieldWidget(
      cursorColor: ColorsConfig.purpleDark,
      hintText: 'Email',
      onChanged: controller.changeSigninLogin,
      onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      focusNode: _focusLogin,
      textInputAction: TextInputAction.next,
    );
  }

  Widget passwordField() {
    return Observer(
      builder: (_) {
        return TextFieldWidget(
          cursorColor: ColorsConfig.purpleDark,
          hintText: 'Senha',
          obscureText: controller.signinObscurePass,
          suffixIcon: IconButton(
            icon: FaIcon(controller.signinObscurePass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 18, color: ColorsConfig.textColor),
            onPressed: controller.toggleSigninObscurePass,
          ),
          onChanged: controller.changeSigninPass,
          keyboardType: TextInputType.text,
          focusNode: _focusPassword,
          textInputAction: TextInputAction.done,
          onEditingComplete: controller.canSignIn ? _signIn : null,
        );
      },
    );
  }

  Widget buildSubmitButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: const EdgeInsets.only(top: 205),
        child: Observer(builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: ColorsConfig.button,
            disabledColor: ColorsConfig.disabledButton,
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            onPressed: controller.canSignIn ? _signIn : null,
            child: Text(
              'Entrar'.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }

  void _signIn() {
    FocusScope.of(context).requestFocus(FocusNode());
    _loadingController.changeVisibility(true);

    controller.submitSignIn().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pushReplacementNamed('/home');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: widget.parentContext, description: error?.message);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
