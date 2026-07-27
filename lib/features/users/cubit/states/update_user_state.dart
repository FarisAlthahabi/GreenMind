part of '../users_cubit.dart';

@immutable
class UpdateUserState extends GeneralUsersState {}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserLoading extends UpdateUserState {}

final class UpdateUserSuccess extends UpdateUserState {
  final String message;
  final UserModel user;

  UpdateUserSuccess(this.message, this.user);
}

final class UpdateUserFail extends UpdateUserState {
  final String error;

  UpdateUserFail(this.error);
}