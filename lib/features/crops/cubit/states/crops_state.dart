part of '../crops_cubit.dart';

@immutable
class CropsState extends GeneralCropsState{}

final class CropsInitial extends CropsState {}

final class CropsLoading extends CropsState {}

final class CropsSuccess extends CropsState {
  final List<CropModel>crops;

  CropsSuccess(this.crops);
}

final class CropsEmpty extends CropsState {
  final String message;

  CropsEmpty(this.message);
}

final class CropsFail extends CropsState {
  final String error;

  CropsFail(this.error);
}
