part of '../crops_cubit.dart';

@immutable
class UpdateCropState extends GeneralCropsState {}

final class UpdateCropInitial extends UpdateCropState {}

final class UpdateCropLoading extends UpdateCropState {}

final class UpdateCropSuccess extends UpdateCropState {
  final String message;
  final CropModel crop;

  UpdateCropSuccess(this.message, this.crop);
}

final class UpdateCropFail extends UpdateCropState {
  final String error;

  UpdateCropFail(this.error);
}
