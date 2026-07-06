part of '../diagnosing_diseases_cubit.dart';

@immutable
class DiagnosingDiseasesState extends GeneralDiagnosingDiseasesState{}

final class DiagnosingDiseasesInitial extends DiagnosingDiseasesState {}

final class DiagnosingDiseasesLoading extends DiagnosingDiseasesState {}

final class DiagnosingDiseasesSuccess extends DiagnosingDiseasesState {}

final class DiagnosingDiseasesFail extends DiagnosingDiseasesState {
  final String error;

  DiagnosingDiseasesFail(this.error);
}
