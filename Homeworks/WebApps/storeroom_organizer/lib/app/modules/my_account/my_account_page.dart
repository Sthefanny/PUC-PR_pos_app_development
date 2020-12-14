import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/login_response.dart';
import '../../shared/widgets/progress_indicator_widget.dart';
import '../loading/loading_widget.dart';
import 'my_account_controller.dart';

class MyAccountPage extends StatefulWidget {
  final String title;
  const MyAccountPage({Key key, this.title = 'MyAccount'}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ModularState<MyAccountPage, MyAccountController> {
  Size _size;
  Future<LoginResponse> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _getUserData();
  }

  Future<void> _getUserData() {
    return controller.getUserData();
  }

  Future<void> refresh() async {
    _userData = _getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: VisualIdentityHelper.buildBackground(),
          child: FutureBuilder<LoginResponse>(
              future: _userData,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return ProgressIndicatorWidget();

                if (snapshot.hasError) {
                  Future.delayed(Duration.zero, () => SnackbarMessages.showError(context: context, description: snapshot.error));
                }

                final _userInfo = snapshot.data;

                addDataToFields(_userInfo);

                return ListView(
                  children: [
                    _buildTop(_userInfo),
                    _buildInfoList(_userInfo),
                  ],
                );
              }),
        ),
        Positioned(
          top: 20,
          child: IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            onPressed: () => Modular.to.pop(),
          ),
        ),
      ],
    );
  }

  void addDataToFields(LoginResponse userInfo) {
    final _daysToExpire = '${userInfo.daysToExpire ?? 0}';
    final _minimumProductListPurchase = '${userInfo.minimumProductListPurchase ?? 0}';

    controller
      ..changeDaysToExpire(_daysToExpire)
      ..changeMinimumShoppingList(_minimumProductListPurchase);
  }

  Widget _buildTop(LoginResponse userInfo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: ColorsConfig.button,
            ),
            margin: const EdgeInsets.only(bottom: 5),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.solidUserCircle,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            userInfo.name ?? '',
            style: themeData.textTheme.headline4.merge(const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoList(LoginResponse userInfo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildEmail(userInfo.email),
          _buildDaysToExpire(userInfo.daysToExpire),
          _buildMinimumShoppingList(userInfo.minimumProductListPurchase),
          _buildPassword(),
        ],
      ),
    );
  }

  Widget _buildCard({Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: _size.width,
      height: 100,
      child: Card(
        color: ColorsConfig.button,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }

  Widget _buildEmail(String email) {
    const String _title = 'Email';

    return _buildCard(
      child: ListTile(
        title: Text(_title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(email ?? '', style: themeData.textTheme.subtitle1.merge(const TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysToExpire(int daysToExpire) {
    const String _title = 'Alerta de expiração';

    return _buildCard(
      child: ListTile(
        title: Text(_title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${daysToExpire ?? 0}',
                  style: themeData.textTheme.subtitle1.merge(const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.pen, color: Colors.white),
          ],
        ),
        onTap: () async {
          await Modular.to.pushNamed('/myAccount/updateUser');
          await refresh();
        },
      ),
    );
  }

  Widget _buildMinimumShoppingList(int minimumProductListPurchase) {
    const String _title = 'Mínimo para lista de compras';

    return _buildCard(
      child: ListTile(
        title: Text(_title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${minimumProductListPurchase ?? 0}',
                  style: themeData.textTheme.subtitle1.merge(const TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            const FaIcon(FontAwesomeIcons.pen, color: Colors.white),
          ],
        ),
        onTap: () async {
          await Modular.to.pushNamed('/myAccount/updateUser');
          await refresh();
        },
      ),
    );
  }

  Widget _buildPassword() {
    const String _title = 'Senha';

    return _buildCard(
      child: ListTile(
        title: Text(_title, style: themeData.textTheme.headline6.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Alterar senha', style: themeData.textTheme.subtitle1.merge(const TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            const FaIcon(FontAwesomeIcons.pen, color: Colors.white),
          ],
        ),
        onTap: () async {
          await Modular.to.pushNamed('/myAccount/updatePassword');
          await refresh();
        },
      ),
    );
  }
}
