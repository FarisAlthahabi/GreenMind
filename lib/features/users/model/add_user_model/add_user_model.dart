import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_user_model.g.dart';

@JsonSerializable()
@immutable
class AddUserModel {
  const AddUserModel({
    String? name,
    String? username,
    String? password,
    UserRoleEnum? role,
  }) : _name = name,
       _username = username,
       _password = password,
       _role = role;

  final String? _name;
  final String? _username;
  final String? _password;
  final UserRoleEnum? _role;

  AddUserModel copyWith({
    String? Function()? name,
    String? Function()? username,
    String? Function()? password,
    UserRoleEnum? Function()? role,
  }) {
    return AddUserModel(
      name: name != null ? name() : _name,
      username: username != null ? username() : _username,
      password: password != null ? password() : _password,
      role: role != null ? role() : _role,
    );
  }

  String get name {
    if (_name == null || _name.isEmpty) {
      throw "name_required".tr();
    }
    return _name;
  }

  String get username {
    if (_username == null || _username.isEmpty) {
      throw "username_required".tr();
    }
    return _username;
  }

  String? get password {
    return _password;
  }

  @JsonKey(fromJson: UserRoleEnum.fromJson, toJson: UserRoleEnum.toJson)
  UserRoleEnum get role {
    if (_role == null) {
      throw "role_required".tr();
    }
    return _role;
  }

  Map<String, dynamic> toJson() => _$AddUserModelToJson(this);

  factory AddUserModel.fromJson(Map<String, dynamic> json) =>
      _$AddUserModelFromJson(json);
}
