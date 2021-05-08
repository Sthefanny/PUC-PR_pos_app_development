import 'package:mobx/mobx.dart';

import '../../shared/configs/auth_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/enums/config_enum.dart';
import '../../shared/repositories/secure_storage_repository.dart';
import '../../shared/utils/user_utils.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  final SecureStorageRepository _secureStorageRepository;
  final AuthConfig _authConfig;

  _SplashControllerBase(this._secureStorageRepository, this._authConfig);

  @observable
  bool tokenIsValid;

  @action
  Future<void> verifyIfTokenIsValid() async {
    final token = await _secureStorageRepository.getItem(ConfigurationEnum.token.toStr);

    if (token.isNotNullOrEmpty()) {
      await _authConfig.addAuth();
      tokenIsValid = true;
      await UserUtils.loadFirebaseKey();
    } else {
      tokenIsValid = false;
    }
  }
}
