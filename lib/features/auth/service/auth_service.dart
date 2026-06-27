import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:green_mind/features/auth/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:green_mind/features/auth/model/sign_up_post_model/sign_up_post_model.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/utils/constants.dart';

part 'auth_service_imp.dart';

abstract class SignInService {
  Future<UserModel> signIn(SignInPostModel signInPostModel);
  Future<void> signUp(SignUpPostModel signUpPostModel);
  // Future<SignInModel> verify(VerifyModel verifyModel);
  // Future<void> resendCode(String email, {bool isForget = false});
  // Future<void> resetPassword(ResetPasswordModel model);
  Future<void> signOut();
}
