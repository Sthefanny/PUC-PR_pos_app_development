import 'package:flutter_modular/flutter_modular.dart';

import '../models/requests/store_request.dart';
import '../models/responses/store_response.dart';
import '../rest_client.dart';

class StoresService extends Disposable {
  final RestClient _repository;

  StoresService(this._repository);

  Future<List<StoreResponse>> listAllStores() async {
    final response = await _repository.listStores();

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar listar os itens da despensa.');
  }

  Future<StoreResponse> getStore(int id) async {
    final response = await _repository.getStore(id);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar retornar o item da despensa.');
  }

  Future<bool> deleteStore(int id) async {
    final response = await _repository.deleteStore(id);

    if (response.response.statusCode >= 200 && response.response.statusCode <= 300) {
      return true;
    }

    return false;
  }

  Future<StoreResponse> createStore(StoreRequest request) async {
    final response = await _repository.createStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar adicionar o item na despensa.');
  }

  Future<StoreResponse> editStore(StoreRequest request) async {
    final response = await _repository.editStore(request);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar editar o item na despensa.');
  }

  @override
  void dispose() {}
}
