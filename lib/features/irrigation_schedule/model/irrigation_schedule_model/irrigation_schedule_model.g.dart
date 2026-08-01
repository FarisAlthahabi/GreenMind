// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irrigation_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IrrigationScheduleModel _$IrrigationScheduleModelFromJson(
  Map<String, dynamic> json,
) => IrrigationScheduleModel(
  id: (json['id'] as num).toInt(),
  plantId: (json['plant_id'] as num).toInt(),
  recommendedDate: json['recommended_date'] as String,
  actualDate: json['actual_date'] as String?,
  isManualOverride: json['is_manual_override'] as bool,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  plant: json['plant'] == null
      ? null
      : PlantModel.fromJson(json['plant'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IrrigationScheduleModelToJson(
  IrrigationScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'plant_id': instance.plantId,
  'recommended_date': instance.recommendedDate,
  'actual_date': instance.actualDate,
  'is_manual_override': instance.isManualOverride,
  'notes': instance.notes,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'plant': instance.plant,
};
