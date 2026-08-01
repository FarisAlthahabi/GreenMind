// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_irrigation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteIrrigationModel _$CompleteIrrigationModelFromJson(
  Map<String, dynamic> json,
) => CompleteIrrigationModel(
  completedSchedule: IrrigationScheduleModel.fromJson(
    json['completed_schedule'] as Map<String, dynamic>,
  ),
  nextSchedule: IrrigationScheduleModel.fromJson(
    json['next_schedule'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CompleteIrrigationModelToJson(
  CompleteIrrigationModel instance,
) => <String, dynamic>{
  'completed_schedule': instance.completedSchedule,
  'next_schedule': instance.nextSchedule,
};
