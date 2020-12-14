import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storeroom_organizer/app/shared/configs/colors_config.dart';

import '../../shared/configs/dio_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/configs/urls_config.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/models/responses/store_item_response.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/widgets/empty_list.dart';
import '../../shared/widgets/progress_indicator_widget.dart';
import '../../shared/widgets/user_header_widget.dart';
import '../loading/loading_controller.dart';
import '../loading/loading_widget.dart';
import 'store_items_controller.dart';

class StoreItemsPage extends StatefulWidget {
  final int storeId;
  final String storeName;

  const StoreItemsPage({Key key, @required this.storeId, @required this.storeName}) : super(key: key);

  @override
  _StoreItemsPageState createState() => _StoreItemsPageState();
}

class _StoreItemsPageState extends ModularState<StoreItemsPage, StoreItemsController> {
  final LoadingController _loadingController = Modular.get();
  Size _size;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await controller.getStoreItems(widget.storeId).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
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
                _buildTop(),
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

  Widget _buildTop() {
    return Row(
      children: [
        Expanded(child: _buildTitle()),
        UserHeaderWidget(parentContext: context),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => Modular.to.pop(),
              color: Colors.white,
            ),
          ),
          Text(
            widget.storeName,
            style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildStoreItemsList() {
    return RefreshIndicator(
      onRefresh: () => controller.getStoreItems(widget.storeId),
      child: Observer(
        builder: (_) {
          if (controller.storeList == null) {
            return ProgressIndicatorWidget();
          }
          if (controller.storeList.isEmpty) {
            return const EmptyList(svgImage: 'empty_store_item', title: 'Sem itens nessa despensa.');
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

  Widget _buildSlidableCard(StoreItemResponse item) {
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

  Widget _buildItemCard(StoreItemResponse item) {
    return InkWell(
      onTap: () async {
        await Modular.to.pushNamed('/storeItemAddEdit', arguments: {'storeId': widget.storeId, 'id': item.id});

        await controller.getStoreItems(widget.storeId);
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImage(item.imageUrl),
                    Expanded(child: Text(item.product, textAlign: TextAlign.center, style: themeData.textTheme.bodyText2)),
                    Text('${item.quantity.toString()} ${controller.getUnitMeaName(item.unitMea)}', style: themeData.textTheme.bodyText2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Validade: ${DateUtils.formatDate(item.expirationDate)}', style: themeData.textTheme.caption.merge(TextStyle(color: item.expiredAlert ? Colors.red : ColorsConfig.textColor))),
                  ],
                ),
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
            placeholderBuilder: (_) => ProgressIndicatorWidget(),
          );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Modular.to.pushNamed('/storeItemAddEdit', arguments: {'storeId': widget.storeId});

        await controller.getStoreItems(widget.storeId);
      },
      child: const FaIcon(FontAwesomeIcons.plus),
    );
  }

  void _deleteItem(int id) {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.deleteItem(storeId: widget.storeId, id: id).then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        controller.getStoreItems(widget.storeId);
        SnackbarMessages.showSuccess(context: context, description: 'Produto excluído da despensa com sucesso!');
      }
    }).catchError((error) async {
      final errorHandled = await DioConfig.handleError(error);
      if (errorHandled != null && errorHandled.success != null && errorHandled.success) {
        _loadingController.changeVisibility(false);
        return _deleteItem(id);
      }
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: errorHandled?.failure.toString());
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
