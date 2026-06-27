// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpPostModel _$SignUpPostModelFromJson(Map<String, dynamic> json) =>
    SignUpPostModel(
      name: json['full_name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$SignUpPostModelToJson(SignUpPostModel instance) =>
    <String, dynamic>{
      'fcm_token': instance.fcmToken,
      'full_name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
