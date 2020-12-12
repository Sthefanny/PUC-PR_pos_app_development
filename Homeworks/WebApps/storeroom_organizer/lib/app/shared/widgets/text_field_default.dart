import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../configs/themes_config.dart';

import '../helpers/form_helper.dart';

class TextFieldWidget extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final Widget suffixIcon;
  final Color cursorColor;
  final int maxLines;
  final TextEditingController textEditingController;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final Function onEditingComplete;
  final TextInputAction textInputAction;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final String initialValue;

  const TextFieldWidget({
    Key key,
    @required this.onChanged,
    this.suffixIcon,
    @required this.hintText,
    @required this.cursorColor,
    this.textEditingController,
    this.maxLines,
    this.inputFormatters,
    this.keyboardType,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.obscureText,
    this.textCapitalization,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        controller: textEditingController,
        onChanged: onChanged,
        cursorColor: cursorColor,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines ?? 1,
        style: themeData.textTheme.bodyText1,
        decoration: FormHelper.getInputDecoration(hintText: hintText, suffixIcon: suffixIcon),
        inputFormatters: inputFormatters ?? [],
        focusNode: focusNode,
        onEditingComplete: onEditingComplete ?? () {},
        textInputAction: textInputAction ?? TextInputAction.done,
        obscureText: obscureText ?? false,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      ),
    );
  }
}
