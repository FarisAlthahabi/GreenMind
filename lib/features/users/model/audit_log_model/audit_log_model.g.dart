// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CauserModel _$CauserModelFromJson(Map<String, dynamic> json) => CauserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  role: UserRoleEnum.fromJson(json['role'] as String),
);

Map<String, dynamic> _$CauserModelToJson(CauserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': UserRoleEnum.toJson(instance.role),
    };
