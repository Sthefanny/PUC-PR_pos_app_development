import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest {
  final int id;
  final String name;
  final int minimumProductListPurchase;
  final int daysToExpire;

  UpdateUserRequest({
    this.id,
    this.name,
    this.minimumProductListPurchase,
    this.daysToExpire,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}
