part of '../plants_cubit.dart';

@immutable
class MarkHarvestedState extends GeneralPlantsState {}

final class MarkHarvestedInitial extends MarkHarvestedState {}

final class MarkHarvestedLoading extends MarkHarvestedState {}

final class MarkHarvestedSuccess extends MarkHarvestedState {
  final String message;
  final PlantModel plant;

  MarkHarvestedSuccess(this.message, this.plant);
}

final class MarkHarvestedFail extends MarkHarvestedState {
  final String error;

  MarkHarvestedFail(this.error);
}