// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserModel _$AddUserModelFromJson(Map<String, dynamic> json) => AddUserModel(
  name: json['name'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
  role: UserRoleEnum.fromJson(json['role'] as String),
);

Map<String, dynamic> _$AddUserModelToJson(AddUserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
      'role': UserRoleEnum.toJson(instance.role),
    };
