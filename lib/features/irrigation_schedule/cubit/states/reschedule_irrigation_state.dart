// lib/features/irrigation/cubit/states/irrigation_schedule_state.dart
part of '../irrigation_schedule_cubit.dart';

@immutable
class RescheduleIrrigationState extends GeneralIrrigationScheduleState {}

final class RescheduleIrrigationInitial extends RescheduleIrrigationState {}

final class RescheduleIrrigationLoading extends RescheduleIrrigationState {}

final class RescheduleIrrigationSuccess extends RescheduleIrrigationState {
  final String message;
  final IrrigationScheduleModel model;

  RescheduleIrrigationSuccess(this.message, this.model);
}

final class RescheduleIrrigationFail extends RescheduleIrrigationState {
  final String error;

  RescheduleIrrigationFail(this.error);
}
