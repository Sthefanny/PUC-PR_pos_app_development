import 'package:flutter_modular/flutter_modular.dart';

import '../configs/dio_config.dart';
import '../models/enums/config_enum.dart';
import '../models/requests/create_user_request.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../repositories/secure_storage_repository.dart';
import '../rest_client.dart';

class AuthService extends Disposable {
  final RestClient _repository;
  final SecureStorageRepository _tokenService;
  final DioConfig _dio;

  AuthService(this._repository, this._tokenService, this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    var response = await _repository.login(request);

    if (response.accessToken != null) {
      _tokenService.setItem(ConfigurationEnum.token.toStr, response.accessToken);
      _tokenService.setItem(ConfigurationEnum.userName.toStr, response.name);
      _dio.addAuth();
    }

    return response;
  }

  Future<bool> logout() async {
    var response = await _repository.logout();

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      _tokenService.deleteAll();
      return true;
    }

    return false;
  }

  Future<LoginResponse> createUser(CreateUserRequest request) async {
    var response = await _repository.createUser(request);

    if (response.id != null && response.id > 0) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar criar usuário.';
  }

  @override
  void dispose() {}
}
