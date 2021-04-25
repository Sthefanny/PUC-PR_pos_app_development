import 'package:flutter_modular/flutter_modular.dart';

import '../models/responses/product_response.dart';
import '../rest_client.dart';

class ProductService extends Disposable {
  final RestClient _repository;

  ProductService(this._repository);

  Future<List<ProductResponse>> listAllProducts() async {
    final response = await _repository.listProducts();

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar listar os produtos.');
  }

  Future<ProductResponse> getProduct(int id) async {
    final response = await _repository.getProduct(id);

    if (response != null) {
      return response;
    }

    throw Exception('Ocorreu um erro ao tentar retornar o produto.');
  }

  @override
  void dispose() {}
}
