// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantModel _$PlantModelFromJson(Map<String, dynamic> json) => PlantModel(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  cropId: (json['crop_id'] as num).toInt(),
  name: json['name'] as String,
  plantingDate: json['planting_date'] as String?,
  harvestDate: json['harvest_date'] as String?,
  baseIrrigationDays: (json['base_irrigation_days'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  healthStatus: json['health_status'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
  crop: json['crop'] == null
      ? null
      : CropModel.fromJson(json['crop'] as Map<String, dynamic>),
  diseaseId: (json['disease_id'] as num?)?.toInt(),
  disease: json['disease'] == null
      ? null
      : DiseaseModel.fromJson(json['disease'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlantModelToJson(PlantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'crop_id': instance.cropId,
      'disease_id': instance.diseaseId,
      'name': instance.name,
      'planting_date': instance.plantingDate,
      'harvest_date': instance.harvestDate,
      'base_irrigation_days': instance.baseIrrigationDays,
      'quantity': instance.quantity,
      'health_status': instance.healthStatus,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'crop': instance.crop,
      'disease': instance.disease,
    };
