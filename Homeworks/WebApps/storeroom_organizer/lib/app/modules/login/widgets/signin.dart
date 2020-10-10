import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/widgets/text_field_default.dart';
import '../login_controller.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends ModularState<SignIn, LoginController> {
  final _focusLogin = FocusNode();
  final _focusPassword = FocusNode();
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 23),
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
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  width: 300,
                  height: 210,
                  child: Column(
                    children: <Widget>[
                      loginField(),
                      Padding(padding: const EdgeInsets.only(bottom: 20)),
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
    return Container(
      child: TextFieldWidget(
        cursorColor: ColorsConfig.loginGradientStart,
        hintText: 'Email',
        onChanged: controller.changeSigninLogin,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
        keyboardType: TextInputType.text,
        focusNode: _focusLogin,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget passwordField() {
    return Container(
      child: Observer(
        builder: (_) {
          return TextFieldWidget(
            cursorColor: ColorsConfig.loginGradientStart,
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
            onEditingComplete: () {},
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
        margin: EdgeInsets.only(top: 205),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: ColorsConfig.button,
          child: Text(
            'Entrar'.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            print('teste');
          },
        ),
      ),
    );
  }
}
