import 'package:json_annotation/json_annotation.dart';

part 'store_item_response.g.dart';

@JsonSerializable()
class StoreItemResponse {
  final int id;
  final int unitMea;
  final String product;
  final int productId;
  final double quantity;
  final String imageUrl;
  final bool expiredAlert;
  final int daysToExpire;
  final String expirationDate;
  final String observation;
  final bool recurrent;

  StoreItemResponse({
    this.id,
    this.unitMea,
    this.product,
    this.productId,
    this.quantity,
    this.imageUrl,
    this.expiredAlert,
    this.daysToExpire,
    this.expirationDate,
    this.observation,
    this.recurrent,
  });

  factory StoreItemResponse.fromJson(Map<String, dynamic> json) => _$StoreItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoreItemResponseToJson(this);
}
