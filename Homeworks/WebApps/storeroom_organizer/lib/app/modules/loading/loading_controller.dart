import 'package:mobx/mobx.dart';

part 'loading_controller.g.dart';

class LoadingController = _LoadingControllerBase with _$LoadingController;

abstract class _LoadingControllerBase with Store {
  @observable
  bool isLoading = false;

  @action
  void changeVisibility(bool value) => isLoading = value;
}
