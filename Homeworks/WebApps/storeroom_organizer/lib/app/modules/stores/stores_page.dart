import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/store_response.dart';
import '../../shared/widgets/empty_list.dart';
import '../../shared/widgets/user_header_widget.dart';
import '../loading/loading_controller.dart';
import '../loading/loading_widget.dart';
import 'stores_controller.dart';

class StoresPage extends StatefulWidget {
  final String title;
  const StoresPage({Key key, this.title = 'Home'}) : super(key: key);

  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends ModularState<StoresPage, StoresController> {
  final LoadingController _loadingController = Modular.get();
  Size _size;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await controller.setUserName();
    await controller.getStores().catchError((error) async {
      final errorHandled = await DioConfig.handleError(error, controller.getStores);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        await initialize();
        return;
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    });
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
                Expanded(child: buildStoreList()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildStoreList() {
    return RefreshIndicator(
      onRefresh: controller.getStores,
      child: Observer(
        builder: (_) {
          if (controller.storeList == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.storeList.isEmpty) {
            return const EmptyList(
              svgImage: 'empty_store',
              title: 'Nenhuma despensa encontrada.',
            );
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

        await controller.getStores();
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
                _buildImage(),
                Expanded(child: Text(item.name, textAlign: TextAlign.center, style: themeData.textTheme.bodyText2)),
                Text(item.totalItems.toString(), style: themeData.textTheme.bodyText2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SvgPicture.asset(
      'assets/images/store.svg',
      height: 80,
      fit: BoxFit.cover,
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Modular.to.pushNamed('/storeAddEdit');

        await controller.getStores();
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
        controller.getStores();
        SnackbarMessages.showSuccess(context: context, description: 'Produto excluído da despensa com sucesso!');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error?.message);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
