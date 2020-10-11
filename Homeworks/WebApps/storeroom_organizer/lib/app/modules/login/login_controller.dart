import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/requests/create_user_request.dart';
import '../../shared/models/requests/login_request.dart';
import '../../shared/services/auth_service.dart';
import 'login_store.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final LoginStore _loginStore;
  final AuthService _authService;

  _LoginControllerBase(this._loginStore, this._authService);

  //begin Store replication

  @computed
  String get signinLogin => _loginStore.signinLogin;
  @computed
  String get signinPass => _loginStore.signinPass;
  @computed
  String get signupName => _loginStore.signupName;
  @computed
  String get signupLogin => _loginStore.signupLogin;
  @computed
  String get signupPass => _loginStore.signupPass;
  @computed
  String get signupConfirmPass => _loginStore.signupConfirmPass;
  @computed
  PageController get pageController => _loginStore.pageController;

  @action
  changeSigninLogin(String value) => _loginStore.changeSigninLogin(value);
  @action
  changeSigninPass(String value) => _loginStore.changeSigninPass(value);
  @action
  changeSignupName(String value) => _loginStore.changeSignupName(value);
  @action
  changeSignupLogin(String value) => _loginStore.changeSignupLogin(value);
  @action
  changeSignupPass(String value) => _loginStore.changeSignupPass(value);
  @action
  changeSignupConfirmPass(String value) => _loginStore.changeSignupConfirmPass(value);
  @action
  changePageController(int value) => _loginStore.changePageController(value);

  //end Store replication

  @observable
  bool signinObscurePass = true;
  @observable
  bool signupObscurePass = true;
  @observable
  bool signupObscureConfirmPass = true;

  @action
  toggleSigninObscurePass() => signinObscurePass = !signinObscurePass;
  @action
  toggleSignupObscurePass() => signupObscurePass = !signupObscurePass;
  @action
  toggleSignupObscureConfirmPass() => signupObscureConfirmPass = !signupObscureConfirmPass;

  @computed
  bool get canSignIn => signinLogin.isNotNullOrEmpty() && signinPass.isNotNullOrEmpty();

  @computed
  bool get isPassEqual => signupPass.isNotNullOrEmpty() && signupConfirmPass.isNotNullOrEmpty() && signupPass == signupConfirmPass;

  @computed
  bool get canSignUp => signupName.isNotNullOrEmpty() && signupLogin.isNotNullOrEmpty() && signupPass.isNotNullOrEmpty() && signupConfirmPass.isNotNullOrEmpty();

  @action
  Future<bool> submitSignIn() async {
    if (canSignIn) {
      var request = LoginRequest(email: signinLogin, password: signinPass);
      var response;

      await _authService.login(request).then((result) => response = result).catchError(DioConfig.handleError);

      return response != null ? true : false;
    }
    return false;
  }

  @action
  Future<bool> submitSignUp() async {
    if (canSignUp) {
      var request = CreateUserRequest(name: signupName, email: signupLogin, password: signupPass);
      var response;

      await _authService.createUser(request).then((result) => response = result).catchError(DioConfig.handleError);

      return response != null ? true : false;
    }
    return false;
  }
}