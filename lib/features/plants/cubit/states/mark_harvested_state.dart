part of '../plants_cubit.dart';

@immutable
class MarkHarvestedState extends GeneralPlantsState {
  @override
  List<Object?> get props => [];
}

final class MarkHarvestedInitial extends MarkHarvestedState {}

final class MarkHarvestedLoading extends MarkHarvestedState {}

final class MarkHarvestedSuccess extends MarkHarvestedState {
  final String message;
  final PlantModel plant;

  MarkHarvestedSuccess(this.message, this.plant);

  @override
  List<Object?> get props => [plant];
}

final class MarkHarvestedFail extends MarkHarvestedState {
  final String error;

  MarkHarvestedFail(this.error);
}
