import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/helpers/visual_identity_helper.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key key, this.title = 'Splash'}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashController> {
  ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _validateRedirection();
    controller.verifyIfTokenIsValid();
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  void _validateRedirection() {
    _disposer = reaction(
      (_) => controller.tokenIsValid,
      (tokenIsValid) {
        tokenIsValid ? Modular.to.pushReplacementNamed('/home') : Modular.to.pushReplacementNamed('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: VisualIdentityHelper.buildBackground(),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
