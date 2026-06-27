import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'sign_in_post_model.g.dart';

@JsonSerializable()
@immutable
class SignInPostModel {
  const SignInPostModel({String? email, String? password, 
  this.fcmToken
  })
    : _email = email,
      _password = password;

  final String? _email;
  final String? _password;

  @JsonKey(name: "fcm_token")
  final String? fcmToken;

  SignInPostModel copyWith({
    String? Function()? email,
    String? Function()? password,
    String? Function()? fcmToken,
  }) {
    return SignInPostModel(
      email: email != null ? email() : _email,
      password: password != null ? password() : _password,
      fcmToken: fcmToken != null ? fcmToken() : this.fcmToken,
    );
  }

  String get email {
    return _email ?? (throw "email_required".tr());
  }

  String get password {
    return _password ?? (throw "password_required".tr());
  }

  String? validateemail() {
    if (_email == null || _email.isEmpty) {
      return "email_required".tr();
    }
    return null;
  }

  String? validatePassword() {
    if (_password == null || _password.isEmpty) {
      return "password_required".tr();
    } else if (_password.length < 8) {
      return "password_short".tr();
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$SignInPostModelToJson(this);

  factory SignInPostModel.fromJson(Map<String, dynamic> json) =>
      _$SignInPostModelFromJson(json);
}
