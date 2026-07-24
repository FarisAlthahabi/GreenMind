// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_crop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCropModel _$AddCropModelFromJson(Map<String, dynamic> json) => AddCropModel(
  nameEn: json['name_en'] as String?,
  nameAr: json['name_ar'] as String?,
  baseIrrigationDays: (json['base_irrigation_days'] as num?)?.toInt(),
);

Map<String, dynamic> _$AddCropModelToJson(AddCropModel instance) =>
    <String, dynamic>{
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'base_irrigation_days': instance.baseIrrigationDays,
    };
