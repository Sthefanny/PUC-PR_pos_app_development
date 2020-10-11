import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/widgets/empty_list.dart';
import '../loading/loading_widget.dart';
import 'home_controller.dart';
import 'widgets/user_header_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  @override
  void initState() {
    super.initState();
    controller.setUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: Container(
            decoration: VisualIdentityHelper.buildBackground(),
            child: Column(
              children: [
                Observer(builder: (_) {
                  return UserHeaderWidget(userName: controller.userName);
                }),
                buildStoreItemsList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget buildStoreItemsList() {
    return RefreshIndicator(
      onRefresh: controller.getStoreItems,
      child: FutureBuilder(
        future: controller.getStoreItems(),
        builder: (_, AsyncSnapshot<List<StoreResponse>> snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          var list = snapshot.data;
          if (list.isEmpty) {
            return EmptyList();
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              var item = list[i];
              return buildItemCard(item);
            },
          );
        },
      ),
    );
  }

  Widget buildItemCard(StoreResponse item) {
    return Container(
      child: Row(
        children: [
          Image.network(item.imageUrl),
          Text(item.product),
          Text(item.quantity.toString()),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () => Modular.to.pushNamed('/storeAddEdit'),
      child: FaIcon(FontAwesomeIcons.plus),
    );
  }
}
