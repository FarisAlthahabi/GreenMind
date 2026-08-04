import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'change_password_model.g.dart';

@JsonSerializable()
@immutable
class ChangePasswordModel {
  const ChangePasswordModel({String? currentPassword, String? newPassword})
    : _currentPassword = currentPassword,
      _newPassword = newPassword;

  final String? _currentPassword;
  final String? _newPassword;

  ChangePasswordModel copyWith({
    String? Function()? currentPassword,
    String? Function()? newPassword,
  }) {
    return ChangePasswordModel(
      currentPassword: currentPassword != null ? currentPassword() : _currentPassword,
      newPassword: newPassword != null ? newPassword() : _newPassword,
    );
  }

  @JsonKey(name: "current_password")
  String get currentPassword {
    if (_currentPassword == null || _currentPassword.isEmpty) {
      throw "current_password_required".tr();
    }
    return _currentPassword;
  }

  @JsonKey(name: "new_password")
  String get newPassword {
    if (_newPassword == null || _newPassword.isEmpty) {
      throw "new_password_required".tr();
    }
    return _newPassword;
  }

  Map<String, dynamic> toJson() => _$ChangePasswordModelToJson(this);

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);
}