// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnosticModel _$DiagnosticModelFromJson(Map<String, dynamic> json) =>
    DiagnosticModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      username: json['username'] as String,
      role: UserRoleEnum.fromJson(json['role'] as String),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      diagnosesCount: (json['diagnoses_count'] as num).toInt(),
    );

Map<String, dynamic> _$DiagnosticModelToJson(DiagnosticModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'role': UserRoleEnum.toJson(instance.role),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'diagnoses_count': instance.diagnosesCount,
    };
