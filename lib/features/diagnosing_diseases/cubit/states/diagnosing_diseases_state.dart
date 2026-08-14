part of '../diagnosing_diseases_cubit.dart';

@immutable
class DiagnosingDiseasesState extends GeneralDiagnosingDiseasesState {
  @override
  List<Object?> get props => [];
}

final class DiagnosingDiseasesInitial extends DiagnosingDiseasesState {}

final class DiagnosingDiseasesLoading extends DiagnosingDiseasesState {}

final class DiagnosingDiseasesSuccess extends DiagnosingDiseasesState {
  final DiagnoseResponseModel diagnoseResponse;

  DiagnosingDiseasesSuccess(this.diagnoseResponse);
}

final class DiagnosingDiseasesFail extends DiagnosingDiseasesState {
  final String error;

  DiagnosingDiseasesFail(this.error);
}
