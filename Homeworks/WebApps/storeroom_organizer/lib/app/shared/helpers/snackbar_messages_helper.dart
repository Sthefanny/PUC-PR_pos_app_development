import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/colors_config.dart';
import '../configs/themes_config.dart';

class SnackbarMessages {
  static Future<dynamic> showError({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: FaIcon(FontAwesomeIcons.exclamationTriangle, color: Colors.red, size: 18),
      descriptionColor: Colors.red,
      description: description,
    ).show(context);
  }

  static Future<dynamic> showSuccess({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: FaIcon(FontAwesomeIcons.check, color: Colors.green, size: 18),
      descriptionColor: ColorsConfig.textColor,
      description: description,
    ).show(context);
  }

  static Future<dynamic> showInfo({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: FaIcon(FontAwesomeIcons.exclamationTriangle, color: Colors.yellow, size: 18),
      descriptionColor: ColorsConfig.textColor,
      description: description,
    ).show(context);
  }

  static Flushbar _buildFlushBar({Widget icon, Color descriptionColor, String description}) {
    return Flushbar(
      messageText: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          description,
          style: themeData.textTheme.bodyText2.merge(TextStyle(color: descriptionColor)),
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: icon,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
    );
  }
}
