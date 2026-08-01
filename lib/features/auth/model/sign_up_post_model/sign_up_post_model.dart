// import 'dart:convert';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:green_mind/global/models/user_role_enum.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';

// part "sign_up_post_model.g.dart";

// @JsonSerializable(explicitToJson: true)
// @immutable
// class SignUpPostModel {
//   const SignUpPostModel({
//     String? name,
//     String? username,
//     // String? email,
//     String? password,
//     this.fcmToken,
//     UserRoleEnum? role,
//   }) : _name = name,
//        _username = username,
//        //  _email = email,
//        _password = password,
//        _role = role;

//   final String? _name;
//   final String? _username;
//   // final String? _email;
//   final String? _password;
//   final UserRoleEnum? _role;

//   @JsonKey(name: "fcm_token")
//   final String? fcmToken;

//   SignUpPostModel copyWith({
//     String? Function()? name,
//     String? Function()? username,
//     // String? Function()? email,
//     String? Function()? password,
//     String? Function()? fcmToken,
//     UserRoleEnum? Function()? role,
//   }) {
//     return SignUpPostModel(
//       name: name != null ? name() : _name,
//       username: username != null ? username() : _username,
//       // email: email != null ? email() : _email,
//       password: password != null ? password() : _password,
//       fcmToken: fcmToken != null ? fcmToken() : this.fcmToken,
//       role: role != null ? role() : _role,
//     );
//   }

//   String get name {
//     if (_name == null || _name.isEmpty) {
//       throw "name_required".tr();
//     }
//     return _name;
//   }

//   String get username {
//     if (_username == null || _username.isEmpty) {
//       throw "username_required".tr();
//     }
//     return _username;
//   }

//   @JsonKey(fromJson: UserRoleEnum.fromJson, toJson: UserRoleEnum.toJson)
//   UserRoleEnum get role {
//     if (_role == null) throw "role_required".tr();
//     return _role;
//   }

//   // String get email {
//   //   if (_email == null || _email.isEmpty) {
//   //     throw "email_required".tr();
//   //   }
//   //   return _email;
//   // }

//   String get password {
//     if (_password == null || _password.isEmpty) {
//       throw "password_required".tr();
//     }
//     return _password;
//   }

//   factory SignUpPostModel.fromJson(Map<String, dynamic> json) =>
//       _$SignUpPostModelFromJson(json);

//   Map<String, dynamic> toJson() => _$SignUpPostModelToJson(this);

//   @override
//   String toString() {
//     return jsonEncode(toJson());
//   }

//   factory SignUpPostModel.fromString(String jsonString) {
//     return SignUpPostModel.fromJson(json.decode(jsonString));
//   }
// }
