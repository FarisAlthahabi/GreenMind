import 'package:easy_localization/easy_localization.dart';

enum UserRoleEnum {
  engineer,
  admin,
  farmer;

  String get displayName => name.tr();

  static UserRoleEnum fromJson(String role) =>
      values.firstWhere((value) => value.name == role, orElse: () => engineer);

  static String toJson(UserRoleEnum role) => role.name;

  String get getApiRoute => name;

  bool get isEngineer => this == engineer;
  bool get isAdmin => this == admin;
  bool get isFarmer => this == farmer;
}
