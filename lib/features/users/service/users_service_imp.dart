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
}
