import 'package:flutter_modular/flutter_modular.dart';

import '../models/requests/update_password_request.dart';
import '../models/requests/update_user_request.dart';
import '../models/responses/login_response.dart';
import '../rest_client.dart';
import '../utils/user_utils.dart';

class UserService extends Disposable {
  final RestClient _repository;

  UserService(this._repository);

  Future<LoginResponse> updateUser(UpdateUserRequest request) async {
    final response = await _repository.updateUser(request);

    await UserUtils.saveUserData(response);

    return response;
  }

  Future<bool> updatePassword(UpdatePasswordRequest request) async {
    final response = await _repository.updatePassword(request);

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {}
}
