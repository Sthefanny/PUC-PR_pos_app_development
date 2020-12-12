import 'package:json_annotation/json_annotation.dart';

part 'store_request.g.dart';

@JsonSerializable()
class StoreRequest {
  final int id;
  final String name;
  final String description;
  final int totalItems;
  final bool expiredItems;

  StoreRequest({
    this.id,
    this.name,
    this.description,
    this.totalItems,
    this.expiredItems,
  });

  factory StoreRequest.fromJson(Map<String, dynamic> json) => _$StoreRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StoreRequestToJson(this);
}
