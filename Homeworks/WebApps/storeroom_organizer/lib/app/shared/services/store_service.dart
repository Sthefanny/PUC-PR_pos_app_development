import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';

import '../models/responses/store_response.dart';
import '../rest_client.dart';

class StoreService extends Disposable {
  final RestClient _repository;

  StoreService(this._repository);

  Future<List<StoreResponse>> listAllItemsFromStore() async {
    var response = await _repository.listStoreItems();

    if (response != null) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar listar os itens da dispensa.';
  }

  Future<StoreResponse> getItemFromStore(int id) async {
    var response = await _repository.getItemFromStore(id);

    if (response != null) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar retornar o item da dispensa.';
  }

  Future<bool> deleteItemFromStore(int id) async {
    var response = await _repository.deleteItemFromStore(id);

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      return true;
    }

    return false;
  }

  Future<StoreResponse> addItemToStore(StoreResponse request) async {
    var response = await _repository.addItemToStore(request);

    if (response != null) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar adicionar o item na dispensa.';
  }

  Future<StoreResponse> editItemToStore(StoreResponse request) async {
    var response = await _repository.editItemToStore(request);

    if (response != null) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar editar o item na dispensa.';
  }

  Future<StoreResponse> addImageToItem(int id, File file) async {
    var response = await _repository.addImageToItem(id, file);

    if (response != null) {
      return response;
    }

    throw 'Ocorreu um erro ao tentar adicionar imagem ao item na dispensa.';
  }

  @override
  void dispose() {}
}
