part of "profile_service.dart";

@Injectable(as: ProfileService)
class ProfileServiceImp implements ProfileService {
  final dio = DioClient();
  static const storagePath = "profile";

  @override
  Future<UserModel> getProfile() async {
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);

      if (!hasNet && getCached != null) {
        return UserModel.fromString(getCached);
      }

      final response = await dio.get("auth/profile");
      final data = response.data["data"] as Map<String, dynamic>;
      final user = UserModel.fromJson(data);

      prefs.setString(storagePath, user.toString());

      return user;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getProfile is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> changePassword(ChangePasswordModel changePasswordModel) async {
    try {
      await dio.put("auth/password", data: changePasswordModel.toJson());
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of changePassword is : $stackTrace");
      rethrow;
    }
  }
}
