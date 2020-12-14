import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/enums/config_enum.dart';
import '../models/responses/login_response.dart';
import '../repositories/secure_storage_repository.dart';

class UserUtils {
  static final SecureStorageRepository _tokenService = Modular.get();

  static Future<void> saveUserData(LoginResponse response) async {
    final _userData = jsonEncode(response.toJson());
    await _tokenService.setItem(ConfigurationEnum.userData.toStr, _userData);
  }

  static Future<void> saveTokens(LoginResponse response) async {
    if (response.accessToken != null) {
      await _tokenService.setItem(ConfigurationEnum.token.toStr, response.accessToken);
      await _tokenService.setItem(ConfigurationEnum.refreshToken.toStr, response.refreshToken);
    }
  }

  static Future<LoginResponse> getUserData() async {
    final json = await _tokenService.getItem(ConfigurationEnum.userData.toStr);
    final response = LoginResponse.fromJson(jsonDecode(json));
    return response;
  }

  static Future<String> getToken() async {
    final token = await _tokenService.getItem(ConfigurationEnum.token.toStr);
    return token;
  }

  static Future<String> getRefreshToken() async {
    final refreshToken = await _tokenService.getItem(ConfigurationEnum.refreshToken.toStr);
    return refreshToken;
  }

  static Future<void> deleteToken() async {
    return _tokenService.deleteItem(ConfigurationEnum.token.toStr);
  }

  static Future<void> deleteAll() async {
    return _tokenService.deleteAll();
  }

  static Future<void> loadFirebaseKey() async {
    try {
      final _userData = await getUserData();
      await FirebaseCrashlytics.instance.setCustomKey('userId', _userData.id);
    } catch (_) {
      return;
    }
  }
}
