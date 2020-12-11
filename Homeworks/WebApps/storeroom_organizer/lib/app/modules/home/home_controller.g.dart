// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $HomeController = BindInject(
  (i) => HomeController(i<StoreService>()),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$userNameAtom = Atom(name: '_HomeControllerBase.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$storeListAtom = Atom(name: '_HomeControllerBase.storeList');

  @override
  ObservableList<StoreResponse> get storeList {
    _$storeListAtom.reportRead();
    return super.storeList;
  }

  @override
  set storeList(ObservableList<StoreResponse> value) {
    _$storeListAtom.reportWrite(value, super.storeList, () {
      super.storeList = value;
    });
  }

  final _$setUserNameAsyncAction =
      AsyncAction('_HomeControllerBase.setUserName');

  @override
  Future<void> setUserName() {
    return _$setUserNameAsyncAction.run(() => super.setUserName());
  }

  @override
  String toString() {
    return '''
userName: ${userName},
storeList: ${storeList}
    ''';
  }
}
