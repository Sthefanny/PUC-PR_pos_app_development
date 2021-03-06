import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final int id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;
  final int minimumProductListPurchase;
  final int daysToExpire;

  LoginResponse({
    this.id,
    this.name,
    this.email,
    this.accessToken,
    this.refreshToken,
    this.minimumProductListPurchase,
    this.daysToExpire,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
