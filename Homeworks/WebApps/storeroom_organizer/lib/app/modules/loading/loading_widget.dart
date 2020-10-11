import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'loading_controller.dart';

class LoadingWidget extends StatefulWidget {
  final String title;
  final Widget child;
  const LoadingWidget({Key key, this.title = 'Loading', this.child}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends ModularState<LoadingWidget, LoadingController> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return LoadingOverlay(
        child: widget.child,
        isLoading: controller.isLoading,
        color: Colors.black,
        progressIndicator: Center(
          child: Container(
            height: 100,
            width: 120,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.purple)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('Carregando...'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
