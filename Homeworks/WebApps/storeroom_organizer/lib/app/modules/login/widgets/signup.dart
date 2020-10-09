import 'package:flutter/material.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/widgets/text_field_default.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
      child: Column(
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
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
        keyboardType: TextInputType.text,
        focusNode: _focusName,
        textInputAction: TextInputAction.next,
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
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
        keyboardType: TextInputType.text,
        focusNode: _focusPassword,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget confirmPassField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.loginGradientStart,
        hintText: 'Confirmação de senha',
        onChanged: (teste) {},
        onEditingComplete: () => FocusScope.of(context).requestFocus(_focusPassword),
        keyboardType: TextInputType.text,
        focusNode: _focusConfirmPass,
        textInputAction: TextInputAction.next,
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
