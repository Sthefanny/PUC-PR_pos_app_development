import 'package:flutter/material.dart';
import '../configs/themes_config.dart';

class FormHelper {
  static InputDecoration getInputDecoration({@required String hintText, Widget suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: _getOutlineInputBorder(),
      focusedBorder: _getOutlineInputBorder(),
      errorBorder: _getOutlineInputBorder(),
      focusedErrorBorder: _getOutlineInputBorder(),
      hintText: hintText,
      hintStyle: themeData.textTheme.bodyText1,
      suffixIcon: suffixIcon,
    );
  }

  static OutlineInputBorder _getOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black.withOpacity(.12)),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
