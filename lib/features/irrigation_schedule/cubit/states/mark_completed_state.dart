// lib/features/irrigation/cubit/states/irrigation_schedule_state.dart
part of '../irrigation_schedule_cubit.dart';

@immutable
class MarkCompletedState extends GeneralIrrigationScheduleState {}

final class MarkCompletedInitial extends MarkCompletedState {}

final class MarkCompletedLoading extends MarkCompletedState {}

final class MarkCompletedSuccess extends MarkCompletedState {
  final String message;
  final CompleteIrrigationModel model;

  MarkCompletedSuccess(this.message, this.model);
}

final class MarkCompletedFail extends MarkCompletedState {
  final String error;

  MarkCompletedFail(this.error);
}
