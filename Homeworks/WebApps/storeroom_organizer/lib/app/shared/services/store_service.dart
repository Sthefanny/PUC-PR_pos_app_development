import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';

import '../models/responses/store_response.dart';
import '../rest_client.dart';

class StoreService extends Disposable {
  final RestClient _repository;

  StoreService(this._repository);

  Future<List<StoreResponse>> listAllItemsFromStore() async {
    final response = await _repository.listStoreItems();

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar listar os itens da despensa.');
  }

  Future<StoreResponse> getItemFromStore(int id) async {
    final response = await _repository.getItemFromStore(id);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar retornar o item da despensa.');
  }

  Future<bool> deleteItemFromStore(int id) async {
    final response = await _repository.deleteItemFromStore(id);

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      return true;
    }

    return false;
  }

  Future<StoreResponse> addItemToStore(StoreResponse request) async {
    final response = await _repository.addItemToStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar adicionar o item na despensa.');
  }

  Future<StoreResponse> editItemToStore(StoreResponse request) async {
    final response = await _repository.editItemToStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar editar o item na despensa.');
  }

  Future<StoreResponse> addImageToItem(int id, File file) async {
    final response = await _repository.addImageToItem(id, file);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar adicionar imagem ao item na despensa.');
  }

  @override
  void dispose() {}
}
