import 'package:json_annotation/json_annotation.dart';

part 'product_request.g.dart';

@JsonSerializable()
class ProductRequest {
  final int id;
  final String name;

  ProductRequest({
    this.id,
    this.name,
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) => _$ProductRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProductRequestToJson(this);
}
