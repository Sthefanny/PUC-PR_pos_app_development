import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest {
  final int id;
  final String name;
  final int minimumProductListPurchase;
  final int daysToExpire;

  UpdateUserRequest({
    @required this.id,
    @required this.name,
    @required this.minimumProductListPurchase,
    @required this.daysToExpire,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}
