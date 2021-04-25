import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/requests/update_user_request.dart';
import '../../shared/models/responses/login_response.dart';
import '../../shared/services/user_service.dart';
import '../../shared/utils/user_utils.dart';

part 'my_account_controller.g.dart';

@Injectable()
class MyAccountController = _MyAccountControllerBase with _$MyAccountController;

abstract class _MyAccountControllerBase with Store {
  final UserService _service;

  _MyAccountControllerBase(this._service);

  @observable
  String daysToExpire;
  @observable
  String minimumShoppingList;

  @action
  String changeDaysToExpire(String value) => daysToExpire = value;
  @action
  String changeMinimumShoppingList(String value) => minimumShoppingList = value;

  Future<LoginResponse> getUserData() async {
    return UserUtils.getUserData();
  }

  @action
  Future<bool> daysToExpireEdit() async {
    try {
      if (daysToExpire != null && daysToExpire.isNotEmpty) {
        final userData = await getUserData();
        final request = UpdateUserRequest(id: userData.id, daysToExpire: int.parse(daysToExpire), minimumProductListPurchase: userData.minimumProductListPurchase, name: userData.name);
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

  @action
  Future<bool> minimumShoppingListEdit() async {
    try {
      if (minimumShoppingList != null && minimumShoppingList.isNotEmpty) {
        final userData = await getUserData();
        final request = UpdateUserRequest(id: userData.id, minimumProductListPurchase: int.parse(minimumShoppingList), daysToExpire: userData.daysToExpire, name: userData.name);
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
