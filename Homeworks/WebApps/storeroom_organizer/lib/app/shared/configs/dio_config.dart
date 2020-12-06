import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/enums/config_enum.dart';

import '../models/responses/error_response.dart';
import '../repositories/secure_storage_repository.dart';

class DioConfig {
  final Dio _dio;
  final SecureStorageRepository _secureStorageRepository;

  DioConfig(this._dio, this._secureStorageRepository);

  static String handleError(dynamic error) {
    switch (error.runtimeType) {
      case DioError:
        final res = (error as DioError).response;
        if (res?.statusCode == 401) {
          Modular.to.popUntil((var route) {
            if (route.isFirst) {
              return true;
            }
            return false;
          });
          Modular.to.pushReplacementNamed('/login');
        }
        final errorResponse = ErrorResponse.fromJson(res.data);
        final messageToShow = StringBuffer();
        if (errorResponse.hasError != null) {
          for (final Map<String, dynamic> error in errorResponse.errorList) {
            messageToShow.writeln(error['message'].toString());
          }
        }
        throw Exception(messageToShow);
        break;
      default:
        const messageToShow = 'Um problema ocorreu.';
        throw Exception(messageToShow);
        break;
    }
  }

  dynamic addAuth() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options) async {
          final token = await _secureStorageRepository.getItem(ConfigurationEnum.token.toStr);
          if (token != null && token.isNotEmpty) {
            // print('Token: $token');
            options.headers.addAll({'Authorization': token});
          }
          return options;
        },
        onResponse: (response) async {
          return response;
        },
        onError: (e) async {
          return e;
        },
      ),
    );
  }
}
