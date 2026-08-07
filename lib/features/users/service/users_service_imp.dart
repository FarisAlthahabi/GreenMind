part of 'users_service.dart';

@Injectable(as: UsersService)
class UsersServiceImp implements UsersService {
  final dio = DioClient();

  @override
  Future<List<UserModel>> getUsers() async {
    const storagePath = "users";
    try {
      final prefs = get<SharedPreferences>();
      bool con = await get<InternetConnectionCubit>().checkInternetConnection();
      final getCached = prefs.getStringList(storagePath);
      if (!con && getCached != null) {
        return getCached.map((e) => UserModel.fromString(e)).toList();
      } else if (!con && getCached == null) {
        throw "no_internet".tr();
      }

      final response = await dio.get("users");
      final data = response.data["data"] as List;
      final users = data
          .map((user) => UserModel.fromJson(user as Map<String, dynamic>))
          .toList();
      final setCache = users.map((user) => user.toString()).toList();
      prefs.setStringList(storagePath, setCache);

      return users;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getUsers is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser(int id) async {
    try {
      final response = await dio.get("users/$id");
      final data = response.data["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getUser $id is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser(AddUserModel model, {int? id}) async {
    try {
      final path = id == null ? "users" : "users/$id";
      final response = await dio.postOrPut(
        path,
        isAdd: id == null,
        data: model.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of updateUser ${id ?? ""} is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedModel<AuditLogModel>> getAuditLogs(
    int userId, {
    int page = 1,
  }) async {
    const storagePath = "audit_logs";
    try {
      final prefs = get<SharedPreferences>();
      bool con = await get<InternetConnectionCubit>().checkInternetConnection();
      final getCached = prefs.getString(storagePath);
      fromJson(json) => AuditLogModel.fromJson(json as Map<String, dynamic>);
      if (!con && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      } else if (!con && (getCached == null || page > 1)) {
        throw "no_internet".tr();
      }

      final queries = {'user_id': userId, 'page': page};
      final response = await dio.get("audit-logs", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final models = PaginatedModel.fromJson(data, fromJson);

      if (page == 1) {
        prefs.setString(storagePath, models.toString());
      }

      return models;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of getAuditLogs is : $stackTrace");
      }
      rethrow;
    }
  }
}
