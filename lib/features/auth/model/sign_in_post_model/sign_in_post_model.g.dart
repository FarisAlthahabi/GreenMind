// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInPostModel _$SignInPostModelFromJson(Map<String, dynamic> json) =>
    SignInPostModel(
      email: json['email'] as String?,
      password: json['password'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$SignInPostModelToJson(SignInPostModel instance) =>
    <String, dynamic>{
      'fcm_token': instance.fcmToken,
      'email': instance.email,
      'password': instance.password,
    };
