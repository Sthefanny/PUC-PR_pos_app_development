import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../modules/loading/loading_controller.dart';
import '../configs/colors_config.dart';
import '../configs/dio_config.dart';
import '../configs/themes_config.dart';
import '../helpers/snackbar_messages_helper.dart';
import '../services/auth_service.dart';
import '../utils/user_utils.dart';

class UserHeaderWidget extends StatelessWidget {
  final LoadingController _loadingController = Modular.get();
  final AuthService _service = Modular.get();
  final BuildContext parentContext;

  UserHeaderWidget({Key key, @required this.parentContext}) : super(key: key);

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
            FutureBuilder<String>(
                future: getUserName(),
                builder: (context, snapshot) {
                  return Container(
                    margin: const EdgeInsets.only(left: 5, right: 10),
                    child: Text(
                      snapshot.data ?? '',
                      style: themeData.textTheme.button.merge(const TextStyle(color: Colors.white)),
                    ),
                  );
                }),
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
        return FutureBuilder<Object>(
            future: getUserName(),
            builder: (context, snapshot) {
              return AlertDialog(
                title: Text('Olá ${snapshot.data ?? ''}, o que deseja fazer?', style: themeData.textTheme.subtitle1),
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
            });
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
              onPressed: _logout,
              child: Text('Sair', style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.purpleDark))),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Modular.to.pop();
    _loadingController.changeVisibility(true);
    _service.logout().then((response) {
      if (response) {
        _loadingController.changeVisibility(false);
        Modular.to.pushNamedAndRemoveUntil('/login', (route) => route.isFirst);
      } else {
        _loadingController.changeVisibility(false);
        SnackbarMessages.showError(context: parentContext, description: 'Erro ao deslogar');
      }
    }).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        _loadingController.changeVisibility(false);
        return _logout();
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: parentContext, description: errorHandled?.failure.toString());
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }

  Future<String> getUserName() async {
    final _userData = await UserUtils.getUserData();
    return _userData.name;
  }
}
