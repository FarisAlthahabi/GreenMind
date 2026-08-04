part of '../diseases_cubit.dart';

@immutable
class DiseasesState extends GeneralDiseasesState {}

final class DiseasesInitial extends DiseasesState {}

final class DiseasesLoading extends DiseasesState {}

final class DiseasesSuccess extends DiseasesState {
  final List<DiseaseModel> diseases;

  DiseasesSuccess(this.diseases);
}

final class DiseasesEmpty extends DiseasesState {
  final String message;

  DiseasesEmpty(this.message);
}

final class DiseasesFail extends DiseasesState {
  final String error;

  DiseasesFail(this.error);
}