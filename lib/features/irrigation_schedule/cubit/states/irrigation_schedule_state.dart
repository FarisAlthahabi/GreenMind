// lib/features/irrigation/cubit/states/irrigation_schedule_state.dart
part of '../irrigation_schedule_cubit.dart';

@immutable
class IrrigationScheduleState extends GeneralIrrigationScheduleState {}

final class IrrigationScheduleInitial extends IrrigationScheduleState {}

final class IrrigationScheduleLoading extends IrrigationScheduleState {}

final class IrrigationScheduleSuccess extends IrrigationScheduleState {
  final List<IrrigationScheduleModel> schedules;

  IrrigationScheduleSuccess(this.schedules);
}

final class IrrigationScheduleEmpty extends IrrigationScheduleState {
  final String message;

  IrrigationScheduleEmpty(this.message);
}

final class IrrigationScheduleFail extends IrrigationScheduleState {
  final String error;

  IrrigationScheduleFail(this.error);
}