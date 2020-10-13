import 'package:json_annotation/json_annotation.dart';

part 'store_response.g.dart';

@JsonSerializable()
class StoreResponse {
  final int id;
  final int unitMea;
  final String product;
  final int productId;
  final double quantity;
  final String imageUrl;

  StoreResponse({
    this.id,
    this.unitMea,
    this.product,
    this.productId,
    this.quantity,
    this.imageUrl,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) => _$StoreResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoreResponseToJson(this);
}
