// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      id: (json['id'] as num).toInt(),
      plantId: (json['plant_id'] as num).toInt(),
      harvestQuantity: (json['harvest_quantity'] as num).toInt(),
      currentQuantity: (json['current_quantity'] as num).toInt(),
      storageLocation: json['storage_location'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      plant: json['plant'] == null
          ? null
          : PlantInventoryModel.fromJson(json['plant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plant_id': instance.plantId,
      'harvest_quantity': instance.harvestQuantity,
      'current_quantity': instance.currentQuantity,
      'storage_location': instance.storageLocation,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'plant': instance.plant,
    };

PlantInventoryModel _$PlantInventoryModelFromJson(Map<String, dynamic> json) =>
    PlantInventoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      cropId: (json['crop_id'] as num?)?.toInt(),
      crop: json['crop'] == null
          ? null
          : CropInventoryModel.fromJson(json['crop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlantInventoryModelToJson(
  PlantInventoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'crop_id': instance.cropId,
  'crop': instance.crop,
};

CropInventoryModel _$CropInventoryModelFromJson(Map<String, dynamic> json) =>
    CropInventoryModel(
      id: (json['id'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
    );

Map<String, dynamic> _$CropInventoryModelToJson(CropInventoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
    };
