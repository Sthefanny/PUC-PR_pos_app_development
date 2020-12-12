import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';

import '../models/requests/store_item_request.dart';
import '../models/responses/store_item_response.dart';
import '../rest_client.dart';

class StoreItemsService extends Disposable {
  final RestClient _repository;

  StoreItemsService(this._repository);

  Future<List<StoreItemResponse>> listAllItemsFromStore(int storeId) async {
    final response = await _repository.listStoreItems(storeId);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar listar os itens da despensa.');
  }

  Future<StoreItemResponse> getItemFromStore(int id) async {
    final response = await _repository.getItemFromStore(id);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar retornar o item da despensa.');
  }

  Future<bool> deleteItemFromStore({int storeId, int id}) async {
    final response = await _repository.deleteItemFromStore(storeId, id);

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      return true;
    }

    return false;
  }

  Future<StoreItemResponse> addItemToStore(StoreItemRequest request) async {
    final response = await _repository.addItemToStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar adicionar o item na despensa.');
  }

  Future<StoreItemResponse> editItemToStore(StoreItemRequest request) async {
    final response = await _repository.editItemToStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar editar o item na despensa.');
  }

  Future<StoreItemResponse> addImageToItem(int id, File file) async {
    final response = await _repository.addImageToItem(id, file);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar adicionar imagem ao item na despensa.');
  }

  @override
  void dispose() {}
}
