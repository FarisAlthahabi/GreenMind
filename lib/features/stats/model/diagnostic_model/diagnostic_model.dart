import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnostic_model.g.dart';

@JsonSerializable()
@immutable
class DiagnosticModel {
  const DiagnosticModel({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.diagnosesCount,
  });

  final int id;
  final String name;
  final String username;

  @JsonKey(fromJson: UserRoleEnum.fromJson, toJson: UserRoleEnum.toJson)
  final UserRoleEnum role;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  @JsonKey(name: "diagnoses_count")
  final int diagnosesCount;

  factory DiagnosticModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosticModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnosticModel.fromString(String jsonString) {
    return DiagnosticModel.fromJson(json.decode(jsonString));
  }

  DiagnosticModel copyWith({
    int? id,
    String? name,
    String? username,
    UserRoleEnum? role,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    int? diagnosesCount,
  }) {
    return DiagnosticModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      diagnosesCount: diagnosesCount ?? this.diagnosesCount,
    );
  }
}