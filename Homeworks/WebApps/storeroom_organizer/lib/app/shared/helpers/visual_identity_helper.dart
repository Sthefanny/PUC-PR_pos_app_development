import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../configs/colors_config.dart';
import '../configs/themes_config.dart';

class VisualIdentityHelper {
  static BoxDecoration buildBackground() {
    const background = BoxDecoration(
      gradient: LinearGradient(
        colors: [ColorsConfig.purpleDark, ColorsConfig.purpleLight],
        begin: FractionalOffset(0, 0),
        end: FractionalOffset(1, 1),
        stops: [0, 1],
      ),
    );

    return background;
  }

  static Widget buildLogo({@required double logoWidth, double fontSize}) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Image.asset(
              'assets/images/storeroom_logo.png',
              width: logoWidth,
            ),
            Text(
              fontSize == null ? 'Organizador de Despensa' : 'Organizador\nde Despensa',
              style: themeData.textTheme.headline5.merge(
                TextStyle(color: Colors.white, fontSize: fontSize ?? 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
