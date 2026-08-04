part of '../profile_cubit.dart';

@immutable
class ProfileState extends GeneralProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserModel user;

  ProfileSuccess(this.user);
}

final class ProfileFail extends ProfileState {
  final String error;

  ProfileFail(this.error);
}