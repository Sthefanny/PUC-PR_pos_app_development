import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/configs/themes_config.dart';
import '../../shared/configs/urls_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/widgets/empty_list.dart';
import '../loading/loading_controller.dart';
import '../loading/loading_widget.dart';
import 'home_controller.dart';
import 'widgets/user_header_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final LoadingController _loadingController = Modular.get();
  Size _size;

  @override
  void initState() {
    super.initState();
    controller
      ..setUserName()
      ..getStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

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
                Expanded(child: buildStoreItemsList()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildStoreItemsList() {
    return RefreshIndicator(
      onRefresh: controller.getStoreItems,
      child: Observer(
        builder: (_) {
          if (controller.storeList == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.storeList.isEmpty) {
            return EmptyList();
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text('Despensa', style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white))),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.storeList.length,
                  itemBuilder: (_, i) {
                    final item = controller.storeList[i];
                    return _buildSlidableCard(item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSlidableCard(StoreResponse item) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: IconSlideAction(
            caption: 'Deletar',
            color: Colors.red,
            iconWidget: const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
            onTap: () => _deleteItem(item.id),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: _buildItemCard(item),
      ),
    );
  }

  Widget _buildItemCard(StoreResponse item) {
    return InkWell(
      onTap: () async {
        await Modular.to.pushNamed('/storeAddEdit', arguments: {'storeId': item.id});

        await controller.getStoreItems();
      },
      child: Container(
        width: _size.width,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImage(item.imageUrl),
                Expanded(child: Text(item.product, textAlign: TextAlign.center, style: themeData.textTheme.bodyText2)),
                Text('${item.quantity.toString()} ${controller.getUnitMeaName(item.unitMea)}', style: themeData.textTheme.bodyText2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return imageUrl.isNotNullOrEmpty()
        ? Image.network(
            '${UrlConfig.baseUrl}$imageUrl',
            height: 80,
            width: 100,
            fit: BoxFit.cover,
          )
        : SvgPicture.asset(
            'assets/images/add_item.svg',
            height: 80,
            fit: BoxFit.cover,
          );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Modular.to.pushNamed('/storeAddEdit');

        await controller.getStoreItems();
      },
      child: const FaIcon(FontAwesomeIcons.plus),
    );
  }

  void _deleteItem(int storeId) {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.deleteItem(storeId).then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        controller.getStoreItems();
        SnackbarMessages.showSuccess(context: context, description: 'Produto excluído da despensa com sucesso!');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error?.message);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
