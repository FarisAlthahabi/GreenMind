import 'package:easy_localization/easy_localization.dart';

enum UserRoleEnum {
  manager,
  farmer;

  String get displayName => name.tr();

  static UserRoleEnum fromJson(String role) =>
      values.firstWhere((value) => value.name == role, orElse: () => farmer);

  static String toJson(UserRoleEnum role) => role.name;

  String get getApiRoute => name;

  bool get isManager => this == manager;
  bool get isFarmer => this == farmer;
}
