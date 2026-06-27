import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/global/dio/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:green_mind/features/auth/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:green_mind/features/auth/model/sign_up_post_model/sign_up_post_model.dart';
import 'package:green_mind/features/auth/service/auth_service.dart';
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';

part 'states/auth_state.dart';
part 'states/sign_in_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.signInService, this.authManagerBloc) : super(AuthInitial());
  final SignInService signInService;
  final AuthManagerBloc? authManagerBloc;

  String? emailView;

  SignInPostModel signInPostModel = const SignInPostModel();
  SignUpPostModel signUpPostModel = const SignUpPostModel();
  // VerifyModel verifyModel = const VerifyModel();
  // ResetPasswordModel resetPasswordModel = const ResetPasswordModel();

  void setEmail(String email) {
    signInPostModel = signInPostModel.copyWith(email: () => email);
  }

  void setPassword(String password) {
    signInPostModel = signInPostModel.copyWith(password: () => password);
  }

  void setName(String name) {
    signUpPostModel = signUpPostModel.copyWith(name: () => name);
  }

  void setEmailSignUp(String email) {
    signUpPostModel = signUpPostModel.copyWith(email: () => email);
  }

  void setPasswordSignUp(String password) {
    signUpPostModel = signUpPostModel.copyWith(password: () => password);
  }

  // void setEmailVerify(String email) {
  //   verifyModel = verifyModel.copyWith(email: () => email);
  // }

  // void setCode(String code) {
  //   verifyModel = verifyModel.copyWith(code: () => code);
  // }

  // void setPasswordReset(String password) {
  //   resetPasswordModel = resetPasswordModel.copyWith(password: () => password);
  // }

  // void setConfirmPasswordReset(String confirmPassword) {
  //   resetPasswordModel = resetPasswordModel.copyWith(
  //     confirmPassword: () => confirmPassword,
  //   );
  // }

  Future<void> signIn({VoidCallback? onSuccess}) async {
    if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;

    emit(SignInLoading());
    try {
      final user = await signInService.signIn(signInPostModel);
      emailView = signInPostModel.email;
      emit(SignInSuccess("login_success".tr(), user));
      authManagerBloc?.add(SignInRequested(user, onSuccess: onSuccess));
    } catch (e) {
      // if (e.toString() == "يجب عليك تأكيد حسابك") {
      //   setEmailVerify(signInPostModel.email);
      //   await sendCode(email: signInPostModel.email);
      // }
      emit(SignInFail(e.toString()));
    }
  }

  Future<void> signUp() async {
    if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;

    emit(SignInLoading());
    try {
      await signInService.signUp(signUpPostModel);
      // setEmailVerify(signUpPostModel.email);
      emailView = signUpPostModel.email;
      signUpPostModel = const SignUpPostModel();
      emit(SignUpSuccess("signup_success".tr()));
    } catch (e) {
      emit(SignInFail(e.toString()));
    }
  }

  Future<void> signOut() async {
    if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;

    emit(SignInLoading());
    try {
      await signInService.signOut();
      emit(SignOutSuccess("logout_success".tr()));
      authManagerBloc?.add(SignOutRequested());
    } catch (e) {
      if (e is UnauthorizedException ||
          e.toString().contains("Token has expired")) {
        emit(SignOutSuccess("logout_success".tr()));
        authManagerBloc?.add(SignOutRequested());
        return;
      }
      emit(SignInFail(e.toString()));
    }
  }

  // Future<void> verify(
  //   String code, {
  //   bool isForget = false,
  //   VoidCallback? onSuccess,
  // }) async {
  //   if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;
  //   setCode(code);

  //   emit(SignInLoading());
  //   try {
  //     final user = await signInService.verify(verifyModel);
  //     emit(VerifySuccess("verify_success".tr(), user));
  //     if (!isForget) {
  //       authManagerBloc?.add(SignInRequested(user, onSuccess: onSuccess));
  //     }
  //   } catch (e) {
  //     emit(SignInFail(e.toString()));
  //   }
  // }

  // Future<void> sendCode({bool isForget = false, required String email}) async {
  //   if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;

  //   emit(SignInLoading());
  //   try {
  //     emailView = email;
  //     await signInService.resendCode(email, isForget: isForget);
  //     if (isForget) setEmailVerify(email);
  //     emit(ResendCodeSuccess("send_success".tr()));
  //   } catch (e) {
  //     emit(SignInFail(e.toString()));
  //   }
  // }

  // Future<void> resetPassword() async {
  //   if (!await get<InternetConnectionCubit>().checkInternetConnection()) return;

  //   final passwordError = resetPasswordModel.validatePasswords();
  //   if (passwordError != null) {
  //     emit(SignInFail(passwordError));
  //     return;
  //   }

  //   emit(SignInLoading());
  //   try {
  //     await signInService.resetPassword(resetPasswordModel);
  //     emit(ResetPasswordSuccess("reset_password_success".tr()));
  //   } catch (e) {
  //     emit(SignInFail(e.toString()));
  //   }
  // }
}
