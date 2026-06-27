// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String?,
  email: json['email'] as String?,
  name: json['full_name'] as String?,
  phone: json['phone_number'] as String?,
  fcmToken: json['fcm_token'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  role: json['role'] == null
      ? UserRoleEnum.farmer
      : UserRoleEnum.fromJson(json['role'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'full_name': instance.name,
  'phone_number': instance.phone,
  'role': UserRoleEnum.toJson(instance.role),
  'fcm_token': instance.fcmToken,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
