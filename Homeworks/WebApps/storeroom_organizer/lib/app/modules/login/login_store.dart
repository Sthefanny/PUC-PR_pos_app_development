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
  String daysToExpire;
  @observable
  String minimumShoppingList;
  @observable
  PageController pageController = PageController();

  @action
  String changeSigninLogin(String value) => signinLogin = value;
  @action
  String changeSigninPass(String value) => signinPass = value;
  @action
  String changeSignupName(String value) => signupName = value;
  @action
  String changeSignupLogin(String value) => signupLogin = value;
  @action
  String changeSignupPass(String value) => signupPass = value;
  @action
  String changeSignupConfirmPass(String value) => signupConfirmPass = value;
  @action
  String changeDaysToExpire(String value) => daysToExpire = value;
  @action
  String changeMinimumShoppingList(String value) => minimumShoppingList = value;
}
