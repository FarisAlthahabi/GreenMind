// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiseaseModel _$DiseaseModelFromJson(Map<String, dynamic> json) => DiseaseModel(
  id: (json['id'] as num).toInt(),
  technicalName: json['technical_name'] as String,
  arName: json['ar_name'] as String,
  enName: json['en_name'] as String,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DiseaseModelToJson(DiseaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'technical_name': instance.technicalName,
      'ar_name': instance.arName,
      'en_name': instance.enName,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
