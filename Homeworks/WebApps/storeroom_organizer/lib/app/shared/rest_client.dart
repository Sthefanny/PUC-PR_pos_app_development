import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import 'configs/urls_config.dart';
import 'models/requests/create_user_request.dart';
import 'models/requests/login_request.dart';
import 'models/requests/store_item_request.dart';
import 'models/requests/store_request.dart';
import 'models/requests/update_password_request.dart';
import 'models/requests/update_user_request.dart';
import 'models/responses/login_response.dart';
import 'models/responses/product_response.dart';
import 'models/responses/store_item_response.dart';
import 'models/responses/store_response.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: UrlConfig.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/Auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @PATCH('/Auth/token/refresh')
  Future<LoginResponse> refreshToken(@Body() Map<String, dynamic> map);

  @POST('/Auth')
  Future<LoginResponse> createUser(@Body() CreateUserRequest request);

  @POST('/User/logout')
  Future<HttpResponse> logout();

  @PUT('/User/update-password')
  Future<HttpResponse> updatePassword(@Body() UpdatePasswordRequest request);

  @PUT('/User')
  Future<LoginResponse> updateUser(@Body() UpdateUserRequest request);

  @GET('/Product/list')
  Future<List<ProductResponse>> listProducts();

  @GET('/Product/{id}')
  Future<ProductResponse> getProduct(@Path() int id);

  @GET('/StoreItem/list/{storeId}')
  Future<List<StoreItemResponse>> listStoreItems(@Path() int storeId);

  @GET('/StoreItem/{id}')
  Future<StoreItemResponse> getItemFromStore(@Path() int id);

  @DELETE('/StoreItem/{storeId}/{id}')
  Future<HttpResponse> deleteItemFromStore(@Path() int storeId, @Path() int id);

  @POST('/StoreItem')
  Future<StoreItemResponse> addItemToStore(@Body() StoreItemRequest request);

  @PUT('/StoreItem')
  Future<StoreItemResponse> editItemToStore(@Body() StoreItemRequest request);

  @POST('/StoreItem/image')
  Future<StoreItemResponse> addImageToItem(@Part() int id, @Part() File file);

  @GET('/Store/list')
  Future<List<StoreResponse>> listStores();

  @GET('/Store/{id}')
  Future<StoreResponse> getStore(@Path() int id);

  @DELETE('/Store/{id}')
  Future<HttpResponse> deleteStore(@Path() int id);

  @POST('/Store')
  Future<StoreResponse> createStore(@Body() StoreRequest request);

  @PUT('/Store')
  Future<StoreResponse> editStore(@Body() StoreRequest request);
}
