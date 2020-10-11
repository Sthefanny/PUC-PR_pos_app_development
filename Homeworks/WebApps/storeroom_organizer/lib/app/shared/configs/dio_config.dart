import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        if (res.statusCode == 401) {
          Modular.to.popUntil((var route) {
            if (route.isFirst) {
              return true;
            }
            return false;
          });
          Modular.to.pushReplacementNamed('/login');
        }
        var errorResponse = ErrorResponse.fromJson(res.data);
        var messageToShow = '';
        if (errorResponse.hasError != null) {
          for (Map<String, dynamic> error in errorResponse.errorList) {
            messageToShow += error['message'].toString();
          }
        }
        throw messageToShow;
        break;
      default:
        var messageToShow = 'Um problema ocorreu.';
        throw messageToShow;
        break;
    }
  }

  dynamic addAuth() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options) async {
          var token = await _secureStorageRepository.getItem('token');
          if (token != null && token.isNotEmpty) {
            print('Token: $token');
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
