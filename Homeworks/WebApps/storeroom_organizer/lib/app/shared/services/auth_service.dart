import 'package:flutter_modular/flutter_modular.dart';

import '../configs/auth_config.dart';
import '../models/requests/create_user_request.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../repositories/secure_storage_repository.dart';
import '../rest_client.dart';
import '../utils/user_utils.dart';

class AuthService extends Disposable {
  final RestClient _repository;
  final SecureStorageRepository _tokenService;
  final AuthConfig _authConfig;

  AuthService(this._repository, this._tokenService, this._authConfig);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _repository.login(request);

    if (response.accessToken != null) {
      await UserUtils.saveTokens(response);
      await UserUtils.saveUserData(response);
      await UserUtils.loadFirebaseKey();
      _authConfig.addAuth();
    }

    return response;
  }

  Future<bool> logout() async {
    final response = await _repository.logout();

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      await _tokenService.deleteAll();
      return true;
    }

    return false;
  }

  Future<LoginResponse> createUser(CreateUserRequest request) async {
    final response = await _repository.createUser(request);

    if (response.id != null && response.id > 0) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar criar usuário.');
  }

  @override
  void dispose() {}
}
