part of '../plants_cubit.dart';

@immutable
class UpdatePlantDiseaseState extends GeneralPlantsState {
  @override
  List<Object?> get props => [];
}

final class UpdatePlantDiseaseInitial extends UpdatePlantDiseaseState {}

final class UpdatePlantDiseaseLoading extends UpdatePlantDiseaseState {}

final class UpdatePlantDiseaseSuccess extends UpdatePlantDiseaseState {
  final String message;
  final PlantModel plant;

  UpdatePlantDiseaseSuccess(this.message, this.plant);
}

final class UpdatePlantDiseaseFail extends UpdatePlantDiseaseState {
  final String error;

  UpdatePlantDiseaseFail(this.error);
}