import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part "sign_up_post_model.g.dart";

@JsonSerializable(explicitToJson: true)
@immutable
class SignUpPostModel {
  const SignUpPostModel({
    String? name,
    String? email,
    String? password,
    this.fcmToken,
  }) : _name = name,
       _email = email,
       _password = password;

  final String? _name;
  final String? _email;
  final String? _password;

  @JsonKey(name: "fcm_token")
  final String? fcmToken;

  SignUpPostModel copyWith({
    String? Function()? name,
    String? Function()? email,
    String? Function()? password,
    String? Function()? fcmToken,
  }) {
    return SignUpPostModel(
      name: name != null ? name() : _name,
      email: email != null ? email() : _email,
      password: password != null ? password() : _password,
      fcmToken: fcmToken != null ? fcmToken() : this.fcmToken,
    );
  }

  @JsonKey(name: "full_name")
  String get name {
    if (_name == null || _name.isEmpty) {
      throw "name_required".tr();
    }
    return _name;
  }

  String get email {
    if (_email == null || _email.isEmpty) {
      throw "email_required".tr();
    }
    return _email;
  }

  String get password {
    if (_password == null || _password.isEmpty) {
      throw "password_required".tr();
    }
    return _password;
  }

  factory SignUpPostModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpPostModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SignUpPostModel.fromString(String jsonString) {
    return SignUpPostModel.fromJson(json.decode(jsonString));
  }
}
