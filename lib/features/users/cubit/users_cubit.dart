import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/users/model/add_user_model/add_user_model.dart';
import 'package:green_mind/features/users/model/audit_log_model/audit_log_model.dart';
import 'package:green_mind/features/users/service/users_service.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/users_state.dart';
part 'states/update_user_state.dart';
part 'states/general_users_state.dart';
part 'states/audit_logs_state.dart';

@injectable
class UsersCubit extends Cubit<GeneralUsersState> {
  UsersCubit({required this.usersService}) : super(GeneralUsersInitial());
  final UsersService usersService;

  List<UserModel> users = [];
  String searchQuery = "";
  String searchAuditQuery = "";

  Timer? _debounceTimer;

  // Audit logs pagination properties
  List<AuditLogModel> auditLogs = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  AddUserModel model = AddUserModel();

  List<UserModel> get getEngineers =>
      users.where((user) => user.role.isEngineer).toList();

  List<UserModel> get getAdmins =>
      users.where((user) => user.role.isAdmin).toList();

  List<UserModel> get getFarmers =>
      users.where((user) => user.role.isFarmer).toList();

  void setModel(UserModel? user) {
    setName(user?.name);
    setUsername(user?.username);
    setRole(user?.role);
  }

  void clearModel() => model = AddUserModel();

  void setName(String? name) {
    model = model.copyWith(name: () => name);
  }

  void setUsername(String? username) {
    model = model.copyWith(username: () => username);
  }

  void setPassword(String? password) {
    model = model.copyWith(password: () => password);
  }

  void setRole(UserRoleEnum? role) {
    model = model.copyWith(role: () => role);
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    search();
  }

  void setSearchAuditQuery(String value, {int? userId}) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getAuditLogs(userId: userId, reset: true);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> getUsers() async {
    final authedUser = Utils.user;
    emit(UsersLoading());
    if (isClosed) return;
    try {
      final users = await usersService.getUsers()
        ..removeWhere((user) => user.role.isAdmin || authedUser?.id == user.id);
      this.users = users;
      search();
    } catch (e) {
      if (isClosed) return;
      emit(UsersFail(e.toString()));
    }
  }

  Future<void> updateUser({int? id}) async {
    if (id == null && model.password == null) {
      emit(UpdateUserFail("password_required".tr()));
      return;
    }

    emit(UpdateUserLoading());
    if (isClosed) return;
    try {
      final user = await usersService.updateUser(model, id: id);
      emit(UpdateUserSuccess("action_done".tr(), user));
      if (id == null) {
        addLocalUser(user);
      } else {
        updateLocalUser(user);
      }
    } catch (e) {
      if (isClosed) return;
      emit(UpdateUserFail(e.toString()));
    }
  }

  void addLocalUser(UserModel user) {
    users.add(user);
    search();
  }

  void updateLocalUser(UserModel user) {
    int index = users.indexWhere((element) => element.id == user.id);
    if (index != -1) {
      users[index] = user;
      search();
    }
  }

  void deleteLocalUser(int id) {
    users.removeWhere((element) => element.id == id);
    search();
  }

  void search() {
    final filtered = users
        .where(
          (user) =>
              user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              user.username.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
    if (filtered.isEmpty) {
      emit(UsersEmpty("no_users".tr()));
    } else {
      emit(UsersSuccess(filtered));
    }
  }

  // Audit logs methods
  Future<void> getAuditLogs({int? userId, bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      auditLogs.clear();
      emit(AuditLogsLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;
      final paginatedLogs = await usersService.getAuditLogs(
        userId: userId,
        page: currentPage,
        search: searchAuditQuery,
      );

      lastPage = paginatedLogs.pagination.lastPage;
      currentPage = paginatedLogs.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        auditLogs = paginatedLogs.data;
      } else {
        auditLogs = [...auditLogs, ...paginatedLogs.data];
      }

      isLoadingMore = false;

      if (auditLogs.isEmpty) {
        emit(AuditLogsEmpty("no_audit_logs".tr()));
      } else {
        emit(
          AuditLogsSuccess(
            auditLogs,
            hasReachedMax: hasReachedMax,
            currentPage: currentPage,
          ),
        );
      }
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(AuditLogsFail(e.toString()));
    }
  }

  Future<void> loadMoreAuditLogs({int? userId}) async {
    if (!hasReachedMax && !isLoadingMore) {
      currentPage++;
      await getAuditLogs(userId: userId);
    }
  }
}
