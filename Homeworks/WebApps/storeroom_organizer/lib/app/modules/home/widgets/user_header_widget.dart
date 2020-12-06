import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/configs/colors_config.dart';
import '../../../shared/configs/themes_config.dart';
import '../../../shared/helpers/snackbar_messages_helper.dart';
import '../../../shared/services/auth_service.dart';
import '../../loading/loading_controller.dart';

class UserHeaderWidget extends StatelessWidget {
  final String userName;
  final LoadingController _loadingController = Modular.get();
  final AuthService _service = Modular.get();

  UserHeaderWidget({Key key, @required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showMenuDialog(context),
      child: Container(
        margin: const EdgeInsets.only(top: 40, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const FaIcon(
              FontAwesomeIcons.solidUserCircle,
              color: Colors.white,
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 10),
              child: Text(
                userName ?? '',
                style: themeData.textTheme.button.merge(const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMenuDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: Text('Olá Stel, o que deseja fazer?', style: themeData.textTheme.subtitle1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Modular.to.pop();
                    showLogoutDialog(context);
                  },
                  color: ColorsConfig.button,
                  child: Text('Sair', style: themeData.textTheme.button.merge(const TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: Modular.to.pop,
                child: Text(
                  'Cancelar',
                  style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.purpleDark)),
                )),
          ],
        );
      },
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: Text('Tem certeza que quer sair?', style: themeData.textTheme.subtitle1),
          actions: [
            TextButton(
              onPressed: Modular.to.pop,
              child: Text('Cancelar', style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.purpleDark))),
            ),
            TextButton(
              onPressed: () {
                try {
                  Modular.to.pop();
                  _loadingController.changeVisibility(true);
                  _service.logout().then((response) {
                    if (response) {
                      _loadingController.changeVisibility(false);
                      Modular.to.pushNamedAndRemoveUntil('/login', (route) => route.isFirst);
                    } else {
                      _loadingController.changeVisibility(false);
                      SnackbarMessages.showError(context: context, description: 'Erro ao deslogar');
                    }
                  });
                } on Exception catch (_) {
                  _loadingController.changeVisibility(false);
                  SnackbarMessages.showError(context: context, description: 'Erro ao deslogar');
                }
              },
              child: Text('Sair', style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.purpleDark))),
            ),
          ],
        );
      },
    );
  }
}
