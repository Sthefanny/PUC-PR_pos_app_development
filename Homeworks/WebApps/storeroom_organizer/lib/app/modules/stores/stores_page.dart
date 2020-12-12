import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/configs/colors_config.dart';
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
  Future<List<StoreResponse>> _storesResponse;
  Size _size;

  @override
  void initState() {
    super.initState();
    _storesResponse = getStores();
  }

  Future<List<StoreResponse>> getStores() async {
    var response = <StoreResponse>[];
    await controller.getStores().then((value) => response = value).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        return getStores();
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    });
    return response;
  }

  Future<void> refresh() async {
    _storesResponse = getStores();
    setState(() {});
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
                FutureBuilder(
                    future: controller.setUserName(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                      return UserHeaderWidget(userName: snapshot.data ?? '');
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
      onRefresh: refresh,
      child: FutureBuilder<List<StoreResponse>>(
        future: _storesResponse,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError) {
            Future.delayed(Duration.zero, () => SnackbarMessages.showError(context: context, description: snapshot.error));
          }

          if (snapshot.connectionState == ConnectionState.done && (!snapshot.hasData || snapshot.data.isEmpty)) {
            return const EmptyList(
              svgImage: 'empty_store',
              title: 'Nenhuma despensa encontrada.',
            );
          }

          final items = snapshot.data;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text('Minhas Despensas', style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white))),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
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
            caption: 'Editar',
            color: Colors.yellow,
            iconWidget: const FaIcon(FontAwesomeIcons.pen),
            onTap: () => _editItem(item.id),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: IconSlideAction(
            caption: 'Deletar',
            color: Colors.red,
            iconWidget: const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
            onTap: () => _showDeleteDialog(storeId: item.id, storeName: item.name),
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
        await Modular.to.pushNamed('/storeItems', arguments: {'storeId': item.id, 'storeName': item.name});

        await refresh();
      },
      child: Stack(
        children: [
          Container(
            width: _size.width,
            height: 100,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(item.name, textAlign: TextAlign.center, style: themeData.textTheme.bodyText2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(getItemText(item.totalItems), style: themeData.textTheme.bodyText2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: item.expiredItems,
            child: const Positioned(
              top: -2,
              right: -2,
              child: Icon(
                Icons.brightness_1,
                size: 20,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getItemText(int totalItems) {
    if (totalItems <= 0) {
      return 'Nenhum item';
    } else if (totalItems == 1) {
      return '$totalItems item';
    }
    return '$totalItems itens';
  }

  Widget _buildImage() {
    return SvgPicture.asset(
      'assets/images/store.svg',
      width: 100,
      fit: BoxFit.cover,
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Modular.to.pushNamed('/storeAddEdit');

        await refresh();
      },
      child: const FaIcon(FontAwesomeIcons.plus),
    );
  }

  void _showDeleteDialog({@required int storeId, @required String storeName}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(storeName),
          content: Text('Tem certeza que quer excluir essa despensa? Essa é uma ação irreversível.', style: themeData.textTheme.bodyText2),
          actions: [
            TextButton(onPressed: () => Modular.to.pop(), child: Text('Cancelar', style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.button)))),
            TextButton(
                onPressed: () {
                  Modular.to.pop();
                  _deleteItem(storeId);
                },
                child: Text('Excluir', style: themeData.textTheme.button.merge(const TextStyle(color: ColorsConfig.button)))),
          ],
        );
      },
    );
  }

  void _deleteItem(int storeId) {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.deleteStore(storeId).then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        refresh();
        SnackbarMessages.showSuccess(context: context, description: 'Despensa excluída com sucesso!');
      }
    }).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        _loadingController.changeVisibility(false);
        return _deleteItem(storeId);
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    }).whenComplete(() {
      refresh();
      _loadingController.changeVisibility(false);
    });
  }

  Future<void> _editItem(int storeId) async {
    await Modular.to.pushNamed('/storeAddEdit', arguments: {'storeId': storeId});

    await refresh();
  }
}
