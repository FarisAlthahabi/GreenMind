part of '../plants_cubit.dart';

@immutable
class PlantsState extends GeneralPlantsState {}

final class PlantsInitial extends PlantsState {}

final class PlantsLoading extends PlantsState {}

final class PlantsSuccess extends PlantsState {
  final List<PlantModel> plants;

  PlantsSuccess(this.plants);
}

final class PlantsEmpty extends PlantsState {
  final String message;

  PlantsEmpty(this.message);
}

final class PlantsFail extends PlantsState {
  final String error;

  PlantsFail(this.error);
}