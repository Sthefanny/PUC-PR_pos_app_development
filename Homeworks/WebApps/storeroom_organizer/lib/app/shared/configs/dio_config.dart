import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/default_response.dart';
import '../models/enums/config_enum.dart';
import '../models/responses/error_response.dart';
import '../repositories/secure_storage_repository.dart';
import '../rest_client.dart';
import '../utils/user_utils.dart';
import 'auth_config.dart';

class DioConfig {
  static Future<DefaultResponse> handleError(
    dynamic error,
  ) async {
    DefaultResponse response;

    switch (error.runtimeType) {
      case DioError:
        final res = (error as DioError).response;
        if (res?.statusCode == 401) {
          if (await refreshToken()) {
            response = DefaultResponse<bool>(success: true);
            break;
          }
          response = DefaultResponse<String>(failure: 'Ocorreu um problema. Por favor, contate o administrador');
          break;
        }
        if (res?.statusCode == 404) {
          await FirebaseCrashlytics.instance.log('Rota não encontrada: ${res?.request?.path}');
          response = DefaultResponse<String>(failure: 'Ocorreu um problema. Por favor, contate o administrador');
          break;
        }
        final messageToShow = StringBuffer();
        try {
          if (res.data != null && res.data != '') {
            final errorResponse = ErrorResponse.fromJson(res.data);
            if (errorResponse.hasError != null) {
              for (final Map<String, dynamic> error in errorResponse.errorList) {
                if (messageToShow.isNotEmpty) {
                  messageToShow.writeln(error['message'].toString());
                } else {
                  messageToShow.write(error['message'].toString());
                }
              }
            }
          } else {
            if (messageToShow.isNotEmpty) {
              messageToShow.writeln(res.statusMessage.toString());
            } else {
              messageToShow.write(res.statusMessage.toString());
            }
          }
        } catch (e) {
          response = DefaultResponse<String>(failure: 'Ocorreu um problema. Por favor, contate o administrador');
          break;
        }

        response = DefaultResponse<String>(failure: messageToShow.toString());
        break;
      default:
        const messageToShow = 'Um problema ocorreu.';
        response = DefaultResponse<String>(failure: messageToShow.toString());
        break;
    }
    return response;
  }

  static Future<bool> refreshToken() async {
    try {
      final RestClient _repository = Modular.get();
      final AuthConfig _authConfig = Modular.get();
      final SecureStorageRepository _secureStorageRepository = Modular.get();

      final refreshToken = await _secureStorageRepository.getItem(ConfigurationEnum.refreshToken.toStr);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await _repository.refreshToken({'refreshToken': refreshToken});

        if (response?.accessToken != null) {
          await UserUtils.saveTokens(response);
          await _authConfig.addAuth();
          return true;
        }
      }
    } catch (_) {
      returnToLogin();
    }
    returnToLogin();
    return false;
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
