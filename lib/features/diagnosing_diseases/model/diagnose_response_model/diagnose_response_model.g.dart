// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnose_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnoseResponseModel _$DiagnoseResponseModelFromJson(
  Map<String, dynamic> json,
) => DiagnoseResponseModel(
  diagnosis: DiagnoseModel.fromJson(json['diagnosis'] as Map<String, dynamic>),
  recommendedIntervalDays: (json['recommended_interval_days'] as num).toInt(),
  details: json['details'] == null
      ? null
      : DiagnoseDetailsModel.fromJson(json['details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DiagnoseResponseModelToJson(
  DiagnoseResponseModel instance,
) => <String, dynamic>{
  'diagnosis': instance.diagnosis,
  'recommended_interval_days': instance.recommendedIntervalDays,
  'details': instance.details,
};
