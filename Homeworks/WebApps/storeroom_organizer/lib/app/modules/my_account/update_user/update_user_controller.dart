import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/models/requests/update_user_request.dart';
import '../../../shared/models/responses/login_response.dart';
import '../../../shared/services/user_service.dart';
import '../../../shared/utils/user_utils.dart';

part 'update_user_controller.g.dart';

@Injectable()
class UpdateUserController = _UpdateUserControllerBase with _$UpdateUserController;

abstract class _UpdateUserControllerBase with Store {
  final UserService _service;

  _UpdateUserControllerBase(this._service);

  @observable
  String daysToExpire;
  @observable
  String minimumShoppingList;

  @action
  String changeDaysToExpire(String value) => daysToExpire = value;
  @action
  String changeMinimumShoppingList(String value) => minimumShoppingList = value;
  @computed
  bool get canUpdate => daysToExpire != null && daysToExpire.isNotEmpty && minimumShoppingList != null && minimumShoppingList.isNotEmpty;

  Future<void> getUserData() async {
    try {
      await UserUtils.getUserData().then(
        (result) {
          if (result != null && result.id != null) {
            changeDaysToExpire('${result.daysToExpire ?? 0}');
            changeMinimumShoppingList('${result.minimumProductListPurchase ?? 0}');
            return;
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<bool> updateUser() async {
    try {
      if (canUpdate) {
        final userData = await UserUtils.getUserData();
        final request = UpdateUserRequest(id: userData.id, daysToExpire: int.parse(daysToExpire), minimumProductListPurchase: int.parse(minimumShoppingList), name: userData.name);
        LoginResponse response;

        await _service.updateUser(request).then((result) {
          response = result;
        });

        return response != null ?? false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
