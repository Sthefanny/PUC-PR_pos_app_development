import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_store.dart';

part 'login_controller.g.dart';

@Injectable()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final LoginStore _loginStore;

  _LoginControllerBase(this._loginStore);

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
}
