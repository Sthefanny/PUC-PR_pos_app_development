import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/enums/config_enum.dart';
import '../../shared/repositories/secure_storage_repository.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  final SecureStorageRepository _secureStorageRepository;
  final DioConfig _dio;

  _SplashControllerBase(this._secureStorageRepository, this._dio);

  @observable
  bool tokenIsValid;

  @action
  Future<void> verifyIfTokenIsValid() async {
    var token = await _secureStorageRepository.getItem(ConfigurationEnum.token.toStr);

    if (token.isNotNullOrEmpty()) {
      await _dio.addAuth();
      tokenIsValid = true;
    } else {
      tokenIsValid = false;
    }
  }
}
