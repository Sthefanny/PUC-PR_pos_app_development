import 'package:json_annotation/json_annotation.dart';

part 'store_item_request.g.dart';

@JsonSerializable()
class StoreItemRequest {
  final int unitMea;
  final String product;
  final int productId;
  final double quantity;
  final String expirationDate;
  final String observation;
  final bool recurrent;
  final int id;
  final int storeId;

  StoreItemRequest({
    this.unitMea,
    this.product,
    this.productId,
    this.quantity,
    this.expirationDate,
    this.observation,
    this.recurrent,
    this.id,
    this.storeId,
  });

  factory StoreItemRequest.fromJson(Map<String, dynamic> json) => _$StoreItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StoreItemRequestToJson(this);
}
