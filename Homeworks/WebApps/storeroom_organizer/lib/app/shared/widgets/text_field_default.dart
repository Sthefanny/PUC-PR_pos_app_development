import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        controller: textEditingController,
        onChanged: onChanged,
        cursorColor: cursorColor,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines ?? 1,
        decoration: _getInputDecoration(),
        inputFormatters: inputFormatters ?? [],
        focusNode: focusNode ?? null,
        onEditingComplete: onEditingComplete ?? () {},
        textInputAction: textInputAction ?? TextInputAction.done,
        obscureText: obscureText ?? false,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: _getOutlineInputBorder(),
      focusedBorder: _getOutlineInputBorder(),
      errorBorder: _getOutlineInputBorder(),
      focusedErrorBorder: _getOutlineInputBorder(),
      hintText: hintText,
      suffixIcon: suffixIcon ?? null,
    );
  }

  OutlineInputBorder _getOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black.withOpacity(.12), width: 1),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
