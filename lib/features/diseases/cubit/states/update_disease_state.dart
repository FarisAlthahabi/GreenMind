part of '../diseases_cubit.dart';

@immutable
class UpdateDiseaseState extends GeneralDiseasesState {}

final class UpdateDiseaseInitial extends UpdateDiseaseState {}

final class UpdateDiseaseLoading extends UpdateDiseaseState {}

final class UpdateDiseaseSuccess extends UpdateDiseaseState {
  final String message;
  final DiseaseModel disease;

  UpdateDiseaseSuccess(this.message, this.disease);
}

final class UpdateDiseaseFail extends UpdateDiseaseState {
  final String error;

  UpdateDiseaseFail(this.error);
}