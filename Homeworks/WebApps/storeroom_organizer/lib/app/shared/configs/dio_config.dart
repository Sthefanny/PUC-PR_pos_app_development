import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/enums/config_enum.dart';
import '../models/responses/error_response.dart';
import '../repositories/secure_storage_repository.dart';
import '../rest_client.dart';

class DioConfig {
  static String handleError(dynamic error) {
    switch (error.runtimeType) {
      case DioError:
        final res = (error as DioError).response;
        if (res?.statusCode == 401) {
          refreshToken();
          break;
        }
        final errorResponse = ErrorResponse.fromJson(res.data);
        final messageToShow = StringBuffer();
        if (errorResponse.hasError != null) {
          for (final Map<String, dynamic> error in errorResponse.errorList) {
            messageToShow.writeln(error['message'].toString());
          }
        }
        throw Exception(messageToShow.toString());
        break;
      default:
        const messageToShow = 'Um problema ocorreu.';
        throw Exception(messageToShow);
        break;
    }
  }

  static Future<void> refreshToken() async {
    try {
      final RestClient _repository = Modular.get();
      final SecureStorageRepository _secureStorageRepository = Modular.get();

      final refreshToken = await _secureStorageRepository.getItem(ConfigurationEnum.refreshToken.toStr);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await _repository.refreshToken(refreshToken);

        if (response?.accessToken != null) {
          await _secureStorageRepository.setItem(ConfigurationEnum.token.toStr, response.accessToken);
          await _secureStorageRepository.setItem(ConfigurationEnum.refreshToken.toStr, response.refreshToken);
          await _secureStorageRepository.setItem(ConfigurationEnum.userName.toStr, response.name);
          return;
        }
      }
    } catch (_) {
      returnToLogin();
    }
    returnToLogin();
  }

  static void returnToLogin() {
    Modular.to.popUntil((var route) {
      if (route.isFirst) {
        return true;
      }
      return false;
    });
    Modular.to.pushReplacementNamed('/login', arguments: {'error': 'Login expirado. Por favor, refaça o login'});
  }
}
