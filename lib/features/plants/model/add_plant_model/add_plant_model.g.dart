// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_plant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPlantModel _$AddPlantModelFromJson(Map<String, dynamic> json) =>
    AddPlantModel(
      cropId: (json['crop_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      plantingDate: json['planting_date'] as String?,
      harvestDate: json['harvest_date'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      healthStatus: json['health_status'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AddPlantModelToJson(AddPlantModel instance) =>
    <String, dynamic>{
      'crop_id': instance.cropId,
      'name': instance.name,
      'planting_date': instance.plantingDate,
      'harvest_date': instance.harvestDate,
      'health_status': instance.healthStatus,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };
