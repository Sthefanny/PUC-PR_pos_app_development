import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/models/requests/update_password_request.dart';
import '../../../shared/services/user_service.dart';

part 'update_password_controller.g.dart';

@Injectable()
class UpdatePasswordController = _UpdatePasswordControllerBase with _$UpdatePasswordController;

abstract class _UpdatePasswordControllerBase with Store {
  final UserService _service;

  _UpdatePasswordControllerBase(this._service);

  @observable
  String oldPassword;
  @observable
  String newPassword;

  @action
  String changeOldPassword(String value) => oldPassword = value;
  @action
  String changeNewPassword(String value) => newPassword = value;
  @computed
  bool get canUpdate => oldPassword != null && oldPassword.isNotEmpty && newPassword != null && newPassword.isNotEmpty;

  @action
  Future<bool> updatePassword() async {
    try {
      if (canUpdate) {
        final request = UpdatePasswordRequest(oldPassword: oldPassword, newPassword: newPassword);
        bool response;

        await _service.updatePassword(request).then((result) {
          response = result;
        });

        return response;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
