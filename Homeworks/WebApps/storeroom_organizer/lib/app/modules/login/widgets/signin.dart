import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:storeroom_organizer/app/shared/configs/colors_config.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        onChanged: (teste) {},
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
        keyboardType: TextInputType.text,
        focusNode: _focusLogin,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget passwordField() {
    return Container(
      child: TextFieldWidget(
        cursorColor: ColorsConfig.loginGradientStart,
        hintText: 'Senha',
        onChanged: (teste) {},
        keyboardType: TextInputType.text,
        focusNode: _focusLogin,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
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
