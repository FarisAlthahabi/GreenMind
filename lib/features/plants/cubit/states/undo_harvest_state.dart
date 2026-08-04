part of '../plants_cubit.dart';

@immutable
class UndoHarvestState extends GeneralPlantsState {}

final class UndoHarvestInitial extends UndoHarvestState {}

final class UndoHarvestLoading extends UndoHarvestState {}

final class UndoHarvestSuccess extends UndoHarvestState {
  final String message;
  final PlantModel plant;

  UndoHarvestSuccess(this.message, this.plant);
}

final class UndoHarvestFail extends UndoHarvestState {
  final String error;

  UndoHarvestFail(this.error);
}