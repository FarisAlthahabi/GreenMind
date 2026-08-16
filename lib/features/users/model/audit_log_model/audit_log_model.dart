import 'dart:convert';

import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'audit_log_model.g.dart';

class AuditLogModel {
  final int id;
  final String description;
  final String entityType;
  final int entityId;
  final CauserModel causer;
  final Map<String, dynamic> oldValues;
  final Map<String, dynamic> newValues;
  final String createdAt;

  AuditLogModel({
    required this.id,
    required this.description,
    required this.entityType,
    required this.entityId,
    required this.causer,
    required this.oldValues,
    required this.newValues,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as int,
      description: json['description'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as int,
      causer: CauserModel.fromJson(json['causer'] as Map<String, dynamic>),
      oldValues: safeCastToMap(json['old_values']),
      newValues: safeCastToMap(json['new_values']),
      // oldValues: json['old_values'] as Map<String, dynamic>,
      // newValues: json['new_values'] as Map<String, dynamic>,
      createdAt: json['created_at'] as String,
    );
  }

  static Map<String, dynamic> safeCastToMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'entity_type': entityType,
      'entity_id': entityId,
      'causer': causer.toJson(),
      'old_values': oldValues,
      'new_values': newValues,
      'created_at': createdAt,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

@immutable
@JsonSerializable()
class CauserModel {
  const CauserModel({required this.id, required this.name, required this.role});

  final int id;
  final String name;

  @JsonKey(fromJson: UserRoleEnum.fromJson, toJson: UserRoleEnum.toJson)
  final UserRoleEnum role;

  factory CauserModel.fromJson(Map<String, dynamic> json) =>
      _$CauserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CauserModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CauserModel.fromString(String jsonString) {
    return CauserModel.fromJson(json.decode(jsonString));
  }
}
