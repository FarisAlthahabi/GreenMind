// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_performance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiPerformanceModel _$AiPerformanceModelFromJson(Map<String, dynamic> json) =>
    AiPerformanceModel(
      totalDiagnoses: (json['total_diagnoses'] as num).toInt(),
      avgConfidence: (json['avg_confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$AiPerformanceModelToJson(AiPerformanceModel instance) =>
    <String, dynamic>{
      'total_diagnoses': instance.totalDiagnoses,
      'avg_confidence': instance.avgConfidence,
    };
