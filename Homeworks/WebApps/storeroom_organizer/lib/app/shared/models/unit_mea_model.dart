import 'package:json_annotation/json_annotation.dart';

part 'unit_mea_model.g.dart';

@JsonSerializable()
class UnitMeaModel {
  final int id;
  final String name;

  UnitMeaModel({
    this.id,
    this.name,
  });

  factory UnitMeaModel.fromJson(Map<String, dynamic> json) => _$UnitMeaModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnitMeaModelToJson(this);
}
