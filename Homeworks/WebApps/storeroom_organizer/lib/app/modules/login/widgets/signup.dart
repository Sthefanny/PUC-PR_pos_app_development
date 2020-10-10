import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/widgets/text_field_default.dart';
import '../login_controller.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends ModularState<SignUp, LoginController> {
  final _focusName = FocusNode();
  final _focusLogin = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPass = FocusNode();
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
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 300,
                  height: 320,
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 20),
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
    return Container(
      child: TextFieldWidget(
        cursorColor: ColorsConfig.loginGradientStart,
        hintText: 'Nome',
        onChanged: (teste) {},
        keyboardType: TextInputType.text,
        focusNode: _focusName,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusLogin),
      ),
    );
  }

  Widget loginField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.loginGradientStart,
        hintText: 'Email',
        onChanged: (teste) {},
        keyboardType: TextInputType.text,
        focusNode: _focusLogin,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
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
            obscureText: controller.signupObscurePass,
            suffixIcon: IconButton(
              icon: FaIcon(controller.signupObscurePass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 18, color: ColorsConfig.textColor),
              onPressed: controller.toggleSignupObscurePass,
            ),
            onChanged: (teste) {},
            keyboardType: TextInputType.text,
            focusNode: _focusPassword,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(_focusConfirmPass),
          );
        },
      ),
    );
  }

  Widget confirmPassField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Observer(
        builder: (_) {
          return TextFieldWidget(
            cursorColor: ColorsConfig.loginGradientStart,
            hintText: 'Confirmação de senha',
            obscureText: controller.signupObscureConfirmPass,
            suffixIcon: IconButton(
              icon: FaIcon(controller.signupObscureConfirmPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 18, color: ColorsConfig.textColor),
              onPressed: controller.toggleSignupObscureConfirmPass,
            ),
            onChanged: (teste) {},
            keyboardType: TextInputType.text,
            focusNode: _focusConfirmPass,
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
        margin: EdgeInsets.only(top: 295),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: ColorsConfig.button,
          child: Text(
            'Criar'.toUpperCase(),
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
