// lib/features/irrigation/cubit/states/irrigation_schedule_state.dart
part of '../irrigation_schedule_cubit.dart';

@immutable
class UndoIrrigationState extends GeneralIrrigationScheduleState {}

final class UndoIrrigationInitial extends UndoIrrigationState {}

final class UndoIrrigationLoading extends UndoIrrigationState {}

final class UndoIrrigationSuccess extends UndoIrrigationState {
  final String message;

  UndoIrrigationSuccess(this.message);
}

final class UndoIrrigationFail extends UndoIrrigationState {
  final String error;

  UndoIrrigationFail(this.error);
}
