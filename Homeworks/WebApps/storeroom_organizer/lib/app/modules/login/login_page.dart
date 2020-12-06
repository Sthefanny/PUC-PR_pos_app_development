import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../loading/loading_widget.dart';
import 'login_controller.dart';
import 'widgets/signin.dart';
import 'widgets/signup.dart';
import 'widgets/tab_indicator_painter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Size _size;
  Color left = Colors.black;
  Color right = Colors.white;
  double _logoWidth = 150;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  width: _size.width,
                  height: _size.height,
                  decoration: VisualIdentityHelper.buildBackground(),
                  child: Column(
                    children: <Widget>[
                      VisualIdentityHelper.buildLogo(logoWidth: _logoWidth),
                      _buildMenuBar(),
                      Expanded(
                        flex: 2,
                        child: _buildMenu(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Observer(builder: (_) {
      return PageView(
        controller: controller.pageController,
        onPageChanged: (i) {
          if (i == 0) {
            setState(() {
              right = Colors.white;
              left = Colors.black;
              _logoWidth = 150;
            });
          } else if (i == 1) {
            setState(() {
              right = Colors.black;
              left = Colors.white;
              _logoWidth = 100;
            });
          }
        },
        children: <Widget>[
          SignIn(),
          SignUp(),
        ],
      );
    });
  }

  Widget _buildMenuBar() {
    return Container(
      width: 300,
      height: 50,
      decoration: const BoxDecoration(
        color: ColorsConfig.menuBar,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Observer(
        builder: (_) {
          if (controller?.pageController == null) return const SizedBox();

          return CustomPaint(
            painter: TabIndicationPainter(pageController: controller.pageController),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => controller.changePageController(0),
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: left, fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => controller.changePageController(1),
                    child: Text(
                      'Criar Conta',
                      maxLines: 1,
                      style: TextStyle(color: right, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
