// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CropModel _$CropModelFromJson(Map<String, dynamic> json) => CropModel(
  id: (json['id'] as num).toInt(),
  nameAr: json['name_ar'] as String,
  nameEn: json['name_en'] as String,
  baseIrrigationDays: (json['base_irrigation_days'] as num).toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CropModelToJson(CropModel instance) => <String, dynamic>{
  'id': instance.id,
  'name_ar': instance.nameAr,
  'name_en': instance.nameEn,
  'base_irrigation_days': instance.baseIrrigationDays,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
