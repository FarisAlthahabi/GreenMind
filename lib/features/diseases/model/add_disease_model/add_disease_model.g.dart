// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_disease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddDiseaseModel _$AddDiseaseModelFromJson(Map<String, dynamic> json) =>
    AddDiseaseModel(
      technicalName: json['technical_name'] as String?,
      enName: json['en_name'] as String?,
      arName: json['ar_name'] as String?,
    );

Map<String, dynamic> _$AddDiseaseModelToJson(AddDiseaseModel instance) =>
    <String, dynamic>{
      'technical_name': instance.technicalName,
      'en_name': instance.enName,
      'ar_name': instance.arName,
    };
