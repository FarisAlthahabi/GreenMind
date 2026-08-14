// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnose_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnoseResponseModel _$DiagnoseResponseModelFromJson(
  Map<String, dynamic> json,
) => DiagnoseResponseModel(
  diagnosis: DiagnoseModel.fromJson(json['diagnosis'] as Map<String, dynamic>),
  recommendation: ScheduleRecommendationModel.fromJson(
    json['schedule_recommendation'] as Map<String, dynamic>,
  ),
  details: json['details'] == null
      ? null
      : DiagnoseDetailsModel.fromJson(json['details'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DiagnoseResponseModelToJson(
  DiagnoseResponseModel instance,
) => <String, dynamic>{
  'diagnosis': instance.diagnosis,
  'schedule_recommendation': instance.recommendation,
  'details': instance.details,
};

ScheduleRecommendationModel _$ScheduleRecommendationModelFromJson(
  Map<String, dynamic> json,
) => ScheduleRecommendationModel(
  intervalDays: (json['recommended_interval_days'] as num).toInt(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$ScheduleRecommendationModelToJson(
  ScheduleRecommendationModel instance,
) => <String, dynamic>{
  'recommended_interval_days': instance.intervalDays,
  'reason': instance.reason,
};
