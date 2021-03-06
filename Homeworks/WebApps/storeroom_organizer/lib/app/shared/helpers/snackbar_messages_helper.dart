import 'package:app_settings/app_settings.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/colors_config.dart';
import '../configs/themes_config.dart';

class SnackbarMessages {
  static dynamic showError({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: const FaIcon(FontAwesomeIcons.exclamationTriangle, color: Colors.red, size: 18),
      descriptionColor: Colors.red,
      description: description,
    ).show(context);
  }

  static dynamic showSuccess({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: const FaIcon(FontAwesomeIcons.check, color: Colors.green, size: 18),
      descriptionColor: ColorsConfig.textColor,
      description: description,
    ).show(context);
  }

  static dynamic showInfo({@required BuildContext context, @required String description}) async {
    return _buildFlushBar(
      icon: const FaIcon(FontAwesomeIcons.exclamationTriangle, color: Colors.yellow, size: 18),
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
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static Future<void> showPermissionErrorSnackbarAndroid({@required BuildContext context}) async {
    await Flushbar(
      messageText: Text(
        'Para continuar, precisamos que você nos dê as permissões necessárias',
        style: themeData.textTheme.bodyText2.merge(const TextStyle(color: Colors.red)),
      ),
      icon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FaIcon(FontAwesomeIcons.exclamationTriangle, color: Colors.red, size: 18),
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static Future<void> showPermissionErrorDialogiOS({@required BuildContext context, @required Color primaryColor}) async {
    const description = 'Para continuar, precisamos que você nos dê as permissões necessárias. Vá em Ajustes e selecione o nosso app para alterar as permissões.';

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Permitir acesso', style: themeData.textTheme.subtitle1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description, style: themeData.textTheme.bodyText2),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Modular.to.pop(),
              child: const Text('cancelar'),
            ),
            const TextButton(
              onPressed: AppSettings.openAppSettings,
              child: Text('ajustes'),
            ),
          ],
        );
      },
    );
  }
}
