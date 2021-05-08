import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/themes_config.dart';
import '../helpers/form_helper.dart';

class DropdownButtonWidget<T> extends StatelessWidget {
  final T value;
  final String hintText;
  final Function onChanged;
  final List<DropdownMenuItem<T>> items;

  const DropdownButtonWidget({
    Key key,
    @required this.value,
    @required this.hintText,
    @required this.onChanged,
    @required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: DropdownButtonFormField(
        value: value,
        icon: const FaIcon(FontAwesomeIcons.chevronDown),
        iconSize: 24,
        elevation: 16,
        decoration: FormHelper.getInputDecoration(hintText: hintText),
        style: themeData.textTheme.bodyText1,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
