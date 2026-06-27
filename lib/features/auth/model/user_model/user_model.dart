import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
@immutable
class UserModel {
  const UserModel({
    required this.id,
    this.username,
    this.email,
    this.name,
    this.phone,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.role = UserRoleEnum.farmer,
  });

  final int id;
  final String? username;
  final String? email;

  @JsonKey(name: "full_name")
  final String? name;

  @JsonKey(name: "phone_number")
  final String? phone;

  @JsonKey(fromJson: UserRoleEnum.fromJson, toJson: UserRoleEnum.toJson)
  final UserRoleEnum role;

  @JsonKey(name: "fcm_token")
  final String? fcmToken;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UserModel.fromString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }
}
