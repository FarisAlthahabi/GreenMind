part of '../diagnosing_diseases_cubit.dart';

@immutable
class DiagnosesDiseasesState extends GeneralDiagnosingDiseasesState {
  @override
  List<Object?> get props => [];
}

final class DiagnosesDiseasesInitial extends DiagnosesDiseasesState {}

final class DiagnosesDiseasesLoading extends DiagnosesDiseasesState {}

final class DiagnosesDiseasesSuccess extends DiagnosesDiseasesState {
  final List<DiagnoseModel> diagnosesDiseases;
  final bool hasReachedMax;
  final int currentPage;

  DiagnosesDiseasesSuccess(
    this.diagnosesDiseases, {
    this.hasReachedMax = false,
    required this.currentPage,
  });
  @override
  List<Object?> get props => [diagnosesDiseases];
}

final class DiagnosesDiseasesEmpty extends DiagnosesDiseasesState {
  final String message;

  DiagnosesDiseasesEmpty(this.message);
}

final class DiagnosesDiseasesFail extends DiagnosesDiseasesState {
  final String error;

  DiagnosesDiseasesFail(this.error);
}
