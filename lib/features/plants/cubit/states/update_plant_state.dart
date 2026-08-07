part of '../plants_cubit.dart';

@immutable
class UpdatePlantState extends GeneralPlantsState {
  @override
  List<Object?> get props => [];
}

final class UpdatePlantInitial extends UpdatePlantState {}

final class UpdatePlantLoading extends UpdatePlantState {}

final class UpdatePlantSuccess extends UpdatePlantState {
  final String message;
  final PlantModel plant;

  UpdatePlantSuccess(this.message, this.plant);
}

final class UpdatePlantFail extends UpdatePlantState {
  final String error;

  UpdatePlantFail(this.error);
}