// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsModel _$StatsModelFromJson(Map<String, dynamic> json) => StatsModel(
  kpis: KpisModel.fromJson(json['kpis'] as Map<String, dynamic>),
  userStats: UserStatsModel.fromJson(
    json['user_stats'] as Map<String, dynamic>,
  ),
  aiPerformance: AiPerformanceModel.fromJson(
    json['ai_performance'] as Map<String, dynamic>,
  ),
  diseaseDistribution: (json['disease_distribution'] as List<dynamic>)
      .map((e) => DiseaseAppearanceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  confidenceRanges: ConfidenceRangesModel.fromJson(
    json['confidence_ranges'] as Map<String, dynamic>,
  ),
  weeklyDiagnoses: (json['weekly_diagnoses'] as List<dynamic>)
      .map((e) => DiagnoseCountModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentDiagnoses: (json['recent_diagnoses'] as List<dynamic>)
      .map((e) => DiagnoseModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  topDiagnostics: (json['top_diagnostics'] as List<dynamic>)
      .map((e) => DiagnosticModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  upcomingSchedules: (json['upcoming_schedules'] as List<dynamic>)
      .map((e) => IrrigationScheduleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StatsModelToJson(StatsModel instance) =>
    <String, dynamic>{
      'kpis': instance.kpis,
      'user_stats': instance.userStats,
      'ai_performance': instance.aiPerformance,
      'disease_distribution': instance.diseaseDistribution,
      'confidence_ranges': instance.confidenceRanges,
      'weekly_diagnoses': instance.weeklyDiagnoses,
      'recent_diagnoses': instance.recentDiagnoses,
      'top_diagnostics': instance.topDiagnostics,
      'upcoming_schedules': instance.upcomingSchedules,
    };
