// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnose_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnoseModel _$DiagnoseModelFromJson(Map<String, dynamic> json) =>
    DiagnoseModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      plantId: (json['plant_id'] as num?)?.toInt(),
      nameTechnical: json['disease_name_technical'] as String,
      nameEn: json['disease_name_english'] as String,
      nameAr: json['disease_name_arabic'] as String,
      confidencePercentage: json['confidence_percentage'] as String,
      originalImagePath: json['original_image_path'] as String,
      gradCamImagePath: json['grad_cam_image_path'] as String,
      treatment: json['treatment'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      plant: json['plant'] == null
          ? null
          : DiagnosePlantModel.fromJson(json['plant'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : DiagnosePlantModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DiagnoseModelToJson(DiagnoseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'plant_id': instance.plantId,
      'disease_name_technical': instance.nameTechnical,
      'disease_name_english': instance.nameEn,
      'disease_name_arabic': instance.nameAr,
      'confidence_percentage': instance.confidencePercentage,
      'original_image_path': instance.originalImagePath,
      'grad_cam_image_path': instance.gradCamImagePath,
      'treatment': instance.treatment,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'plant': instance.plant,
      'user': instance.user,
    };

DiagnosePlantModel _$DiagnosePlantModelFromJson(Map<String, dynamic> json) =>
    DiagnosePlantModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DiagnosePlantModelToJson(DiagnosePlantModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
