import 'package:json_annotation/json_annotation.dart';

part 'store_response.g.dart';

@JsonSerializable()
class StoreResponse {
  final int id;
  final String name;
  final String description;
  final int totalItems;
  final bool expiredItems;

  StoreResponse({
    this.id,
    this.name,
    this.description,
    this.totalItems,
    this.expiredItems,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) => _$StoreResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoreResponseToJson(this);
}
