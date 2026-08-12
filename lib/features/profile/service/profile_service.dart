import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/profile/model/change_password_model/change_password_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_service_imp.dart';

abstract class ProfileService {
  Future<UserModel> getProfile();
  Future<void> changePassword(ChangePasswordModel changePasswordModel);
}