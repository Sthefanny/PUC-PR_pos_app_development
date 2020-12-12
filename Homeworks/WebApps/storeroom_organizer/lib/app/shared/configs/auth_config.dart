import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../models/enums/config_enum.dart';
import '../repositories/secure_storage_repository.dart';
import 'urls_config.dart';

class AuthConfig {
  final Dio _dio;
  final SecureStorageRepository _secureStorageRepository;

  AuthConfig(this._dio, this._secureStorageRepository);

  dynamic addAuth() {
    _dio.interceptors
      ..add(
        InterceptorsWrapper(
          onRequest: (options) async {
            final token = await _secureStorageRepository.getItem(ConfigurationEnum.token.toStr);
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
      )
      ..add(DioCacheManager(CacheConfig(baseUrl: UrlConfig.baseUrl)).interceptor);
  }
}
