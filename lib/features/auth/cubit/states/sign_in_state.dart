part of '../auth_cubit.dart';

@immutable
class SignInState extends AuthState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final String message;
  final UserModel user;

  SignInSuccess(this.message, this.user);
}

final class SignUpSuccess extends SignInState {
  final String message;

  SignUpSuccess(this.message);
}

final class VerifySuccess extends SignInState {
  final String message;
  final UserModel? user;

  VerifySuccess(this.message, this.user);
}

final class ResendCodeSuccess extends SignInState {
  final String message;

  ResendCodeSuccess(this.message);
}

final class ResetPasswordSuccess extends SignInState {
  final String message;

  ResetPasswordSuccess(this.message);
}

final class SignInFail extends SignInState {
  final String error;

  SignInFail(this.error);
}

final class SignOutSuccess extends SignInState {
  final String message;

  SignOutSuccess(this.message);
}
