import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/users/model/add_user_model/add_user_model.dart';
import 'package:green_mind/features/users/model/audit_log_model/audit_log_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/models/paginated_model/paginated_model.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'users_service_imp.dart';

abstract class UsersService {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUser(int id);
  Future<UserModel> updateUser(AddUserModel model, {int? id});
  Future<PaginatedModel<AuditLogModel>> getAuditLogs(
    int userId, {
    int page = 1,
    String? search,
  });
}
