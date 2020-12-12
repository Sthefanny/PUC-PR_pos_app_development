import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/configs/themes_config.dart';
import '../../shared/helpers/snackbar_messages_helper.dart';
import '../../shared/helpers/visual_identity_helper.dart';
import '../../shared/widgets/text_field_default.dart';
import '../loading/loading_controller.dart';
import '../loading/loading_widget.dart';
import 'store_add_edit_controller.dart';

class StoreAddEditPage extends StatefulWidget {
  final String title;
  final int storeId;
  const StoreAddEditPage({Key key, this.title = 'StoreAddEdit', this.storeId}) : super(key: key);

  @override
  _StoreAddEditPageState createState() => _StoreAddEditPageState();
}

class _StoreAddEditPageState extends ModularState<StoreAddEditPage, StoreAddEditController> {
  final LoadingController _loadingController = Modular.get();
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: LoadingWidget(
          child: Container(
            decoration: VisualIdentityHelper.buildBackground(),
            child: ListView(
              children: [
                _buildTitle(),
                _buildBody(),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
            'Criar despensa',
            style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          _buildNameField(),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.purpleDark,
        hintText: 'Nome',
        onChanged: controller.changeNewStoreName,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFieldWidget(
        cursorColor: ColorsConfig.purpleDark,
        hintText: 'Descrição',
        onChanged: controller.changeNewStoreDescription,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 6,
      ),
    );
  }

  Widget _buildButton() {
    return Center(
      child: Container(
        width: _size.width * 0.5,
        height: 50,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: Observer(builder: (_) {
          return RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: ColorsConfig.button,
            disabledColor: ColorsConfig.disabledButton,
            textColor: Colors.white,
            disabledTextColor: Colors.grey,
            onPressed: controller.canAddNewStore ? _createStore : null,
            child: Text(
              'Criar'.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }

  void _createStore() {
    FocusScope.of(context).requestFocus(FocusNode());

    _loadingController.changeVisibility(true);

    controller.createStore().then((result) {
      _loadingController.changeVisibility(false);
      if (result) {
        Modular.to.pop();
        SnackbarMessages.showSuccess(context: context, description: 'Despensa criada com sucesso!');
      }
    }).catchError((error) {
      _loadingController.changeVisibility(false);
      SnackbarMessages.showError(context: context, description: error?.message);
    }).whenComplete(() => _loadingController.changeVisibility(false));
  }
}
