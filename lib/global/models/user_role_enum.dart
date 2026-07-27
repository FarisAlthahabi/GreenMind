import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';

enum UserRoleEnum implements DropDownItemModel {
  engineer,
  admin,
  farmer;

  @override
  String get displayName => name.tr();

  Color get color {
    switch (this) {
      case UserRoleEnum.admin:
        return Colors.purple;
      case UserRoleEnum.engineer:
        return Colors.blue;
      case UserRoleEnum.farmer:
        return Colors.green;
    }
  }

  static UserRoleEnum fromJson(String role) =>
      values.firstWhere((value) => value.name == role, orElse: () => engineer);

  static String toJson(UserRoleEnum role) => role.name;

  String get getApiRoute => name;

  bool get isEngineer => this == engineer;
  bool get isAdmin => this == admin;
  bool get isFarmer => this == farmer;

  @override
  String? get description => null;

  @override
  int get id => index + 1;
}
