part of '../profile_cubit.dart';

@immutable
class ChangePasswordState extends GeneralProfileState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  ChangePasswordSuccess(this.message);
}

final class ChangePasswordFail extends ChangePasswordState {
  final String error;

  ChangePasswordFail(this.error);
}