import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  String signinLogin;
  @observable
  String signinPass;
  @observable
  String signupName;
  @observable
  String signupLogin;
  @observable
  String signupPass;
  @observable
  String signupConfirmPass;
  @observable
  PageController pageController = PageController();

  @action
  changeSigninLogin(String value) => signinLogin = value;
  @action
  changeSigninPass(String value) => signinPass = value;
  @action
  changeSignupName(String value) => signupName = value;
  @action
  changeSignupLogin(String value) => signupLogin = value;
  @action
  changeSignupPass(String value) => signupPass = value;
  @action
  changeSignupConfirmPass(String value) => signupConfirmPass = value;
  @action
  changePageController(int value) {
    pageController?.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
