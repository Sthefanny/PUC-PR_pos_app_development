import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'models/requests/create_user_request.dart';
import 'models/requests/login_request.dart';
import 'models/responses/login_response.dart';
import 'models/responses/product_response.dart';
import 'models/responses/store_response.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'http://gonzagahouse.ddns-intelbras.com.br:600')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/User/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/User/logout')
  Future<HttpResponse> logout();

  @POST('/User')
  Future<LoginResponse> createUser(@Body() CreateUserRequest request);

  @GET('/Product/list')
  Future<List<ProductResponse>> listProducts();

  @GET('/Product/{id}')
  Future<ProductResponse> getProduct(@Path() int id);

  @GET('/Store/list')
  Future<List<StoreResponse>> listStoreItems();

  @GET('/Store/{id}')
  Future<StoreResponse> getItemFromStore(@Path() int id);

  @DELETE('/Store/{id}')
  Future<HttpResponse> deleteItemFromStore(@Path() int id);

  @POST('/Store')
  Future<StoreResponse> addItemToStore(@Body() StoreResponse request);

  @PUT('/Store')
  Future<StoreResponse> editItemToStore(@Body() StoreResponse request);

  @POST('/Store/image')
  Future<StoreResponse> addImageToItem(@Part() int id, @Part() File file);
}