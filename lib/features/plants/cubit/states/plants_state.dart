part of '../plants_cubit.dart';

@immutable
class PlantsState extends GeneralPlantsState {
  @override
  List<Object?> get props => [];
}

final class PlantsInitial extends PlantsState {}

final class PlantsLoading extends PlantsState {}

final class PlantsSuccess extends PlantsState {
  final List<PlantModel> plants;
  final bool hasReachedMax;
  final int currentPage;

  PlantsSuccess(
    this.plants, {
    this.hasReachedMax = false,
    required this.currentPage,
  });
  @override
  List<Object?> get props => [plants];
}

final class PlantsEmpty extends PlantsState {
  final String message;

  PlantsEmpty(this.message);
}

final class PlantsFail extends PlantsState {
  final String error;

  PlantsFail(this.error);
}
