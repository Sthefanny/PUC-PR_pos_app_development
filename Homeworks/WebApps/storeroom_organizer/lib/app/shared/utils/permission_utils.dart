import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '../configs/colors_config.dart';
import '../helpers/snackbar_messages_helper.dart';

class PermissionUtils {
  static Future<bool> checkStoragePermission() async {
    final _status = Platform.isAndroid ? await Permission.storage.request() : await Permission.photos.request();
    return _status == PermissionStatus.granted;
  }

  static Future<bool> checkCameraPermission() async {
    final _status = await Permission.camera.request();
    return _status == PermissionStatus.granted;
  }

  static Future<void> showPermissionError(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Platform.isIOS ? await SnackbarMessages.showPermissionErrorDialogiOS(context: context, primaryColor: ColorsConfig.button) : SnackbarMessages.showPermissionErrorSnackbarAndroid(context: context);
  }
}
