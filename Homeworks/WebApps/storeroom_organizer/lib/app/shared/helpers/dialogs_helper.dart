import 'package:flutter/material.dart';

import '../configs/colors_config.dart';
import '../configs/themes_config.dart';

class Dialogs {
  static Future<void> showDefaultDialog({@required BuildContext context, @required String title, @required String description, @required List<Widget> actions}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? '', style: themeData.textTheme.subtitle1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description ?? '', style: themeData.textTheme.bodyText2.merge(const TextStyle(color: ColorsConfig.textColor))),
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}
