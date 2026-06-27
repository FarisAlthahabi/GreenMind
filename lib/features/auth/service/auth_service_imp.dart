part of "auth_service.dart";

@Injectable(as: SignInService)
class SignInServiceImp implements SignInService {
  final dio = DioClient();

  @override
  Future<UserModel> signIn(SignInPostModel signInPostModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fcmToken = prefs.getString("fcm_token");
      signInPostModel = signInPostModel.copyWith(fcmToken: () => fcmToken);
      final map = signInPostModel.toJson();
      // final response = await dio.post("/api/auth/login", data: map);
       final response = await dio.post("/customer/login", data: map);

      final data = response.data as Map<String, dynamic>;
      final token = data["token"] as String;
      prefs.setString("token", token);

      //refreshToken();
      return UserModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of signin : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await dio.post("/customer/logout");
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of signOut $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> signUp(SignUpPostModel signUpPostModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fcmToken = prefs.getString("fcm_token");
      signUpPostModel = signUpPostModel.copyWith(fcmToken: () => fcmToken);

      final data = signUpPostModel.toJson();
      const duration = AppConstants.duration1m;
      final resposne = await dio.post(
        "/customer/register",
        data: data,
        duration: duration,
      );
      prefs.setString("token", resposne.data["token"]);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of signUp is $stackTrace");
      rethrow;
    }
  }

  // @override
  // Future<UserModel> verify(VerifyModel verifyModel) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final fcmToken = prefs.getString("fcm_token");
  //     verifyModel = verifyModel.copyWith(fcmToken: () => fcmToken);
  //     final map = verifyModel.toJson();
  //     final response = await dio.post("/customer/verify", data: map);

  //     final data = response.data["data"] as Map<String, dynamic>;
  //     final token = data["token"];
  //     prefs.setString("token", token);

  //     return UserModel.fromJson(data);
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) print("stackTrace of verify is $stackTrace");
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> resendCode(String email, {bool isForget = false}) async {
  //   try {
  //     final endPoint = isForget
  //         ? "/customer/forget-password"
  //         : "/customer/verify/send-code";
  //     await dio.post(
  //       endPoint,
  //       data: {"email": email},
  //       duration: AppConstants.duration1m,
  //     );
  //   } catch (e, stackTrace) {
  //     final message = isForget ? "code" : "send-code";
  //     if (kDebugMode) print("stackTrace of $message : $stackTrace");
  //     rethrow;
  //   }
  // }

  // @override
  // Future<void> resetPassword(ResetPasswordModel model) async {
  //   try {
  //     await dio.post("/customer/reset-password", data: model.toJson());
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) print("stackTrace of resetPassword is $stackTrace");
  //     rethrow;
  //   }
  // }
}
