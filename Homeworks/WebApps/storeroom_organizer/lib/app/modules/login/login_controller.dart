import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/extensions/string_extensions.dart';
import '../../shared/models/requests/create_user_request.dart';
import '../../shared/models/requests/login_request.dart';
import '../../shared/models/responses/login_response.dart';
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
  String get daysToExpire => _loginStore.daysToExpire;
  @computed
  String get minimumShoppingList => _loginStore.minimumShoppingList;
  @computed
  PageController get pageController => _loginStore.pageController;

  @action
  String changeSigninLogin(String value) => _loginStore.changeSigninLogin(value);
  @action
  String changeSigninPass(String value) => _loginStore.changeSigninPass(value);
  @action
  String changeSignupName(String value) => _loginStore.changeSignupName(value);
  @action
  String changeSignupLogin(String value) => _loginStore.changeSignupLogin(value);
  @action
  String changeSignupPass(String value) => _loginStore.changeSignupPass(value);
  @action
  String changeSignupConfirmPass(String value) => _loginStore.changeSignupConfirmPass(value);
  @action
  String changeDaysToExpire(String value) => _loginStore.changeDaysToExpire(value);
  @action
  String changeMinimumShoppingList(String value) => _loginStore.changeMinimumShoppingList(value);

  @action
  Future<void> changePageController(int value) {
    return _loginStore.pageController?.animateToPage(value, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  //end Store replication

  @observable
  bool signinObscurePass = true;
  @observable
  bool signupObscurePass = true;
  @observable
  bool signupObscureConfirmPass = true;

  @action
  bool toggleSigninObscurePass() => signinObscurePass = !signinObscurePass;
  @action
  bool toggleSignupObscurePass() => signupObscurePass = !signupObscurePass;
  @action
  bool toggleSignupObscureConfirmPass() => signupObscureConfirmPass = !signupObscureConfirmPass;

  @computed
  bool get canSignIn => signinLogin.isNotNullOrEmpty() && signinPass.isNotNullOrEmpty();

  @computed
  bool get isPassEqual => signupPass.isNotNullOrEmpty() && signupConfirmPass.isNotNullOrEmpty() && signupPass == signupConfirmPass;

  @computed
  bool get canSignUp =>
      signupName.isNotNullOrEmpty() &&
      signupLogin.isNotNullOrEmpty() &&
      signupPass.isNotNullOrEmpty() &&
      signupConfirmPass.isNotNullOrEmpty() &&
      daysToExpire.isNotNullOrEmpty() &&
      minimumShoppingList.isNotNullOrEmpty();

  @action
  Future<bool> submitSignIn() async {
    try {
      if (canSignIn) {
        final request = LoginRequest(email: signinLogin, password: signinPass);
        LoginResponse response;

        await _authService.login(request).then((result) {
          response = result;
        });

        return response != null ?? false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<LoginResponse> submitSignUp() async {
    try {
      LoginResponse response;
      if (canSignUp) {
        final request = CreateUserRequest(name: signupName, email: signupLogin, password: signupPass);

        response = await _authService.createUser(request).then((result) async => result);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
