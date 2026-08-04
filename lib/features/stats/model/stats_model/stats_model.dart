import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/features/stats/model/ai_performance_model/ai_performance_model.dart';
import 'package:green_mind/features/stats/model/confidence_ranges/confidence_ranges.dart';
import 'package:green_mind/features/stats/model/diagnose_count_model/diagnose_count_model.dart';
import 'package:green_mind/features/stats/model/diagnostic_model/diagnostic_model.dart';
import 'package:green_mind/features/stats/model/disease_appearance_model/disease_appearance_model.dart';
import 'package:green_mind/features/stats/model/kpis_model/kpis_model.dart';
import 'package:green_mind/features/stats/model/user_stats_model/user_stats_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats_model.g.dart';

@JsonSerializable()
@immutable
class StatsModel {
  const StatsModel({
    required this.kpis,
    required this.userStats,
    required this.aiPerformance,
    required this.diseaseDistribution,
    required this.confidenceRanges,
    required this.weeklyDiagnoses,
    required this.recentDiagnoses,
    required this.topDiagnostics,
    required this.upcomingSchedules,
  });
  
  final KpisModel kpis;

  @JsonKey(name: "user_stats")
  final UserStatsModel userStats;

  @JsonKey(name: 'ai_performance')
  final AiPerformanceModel aiPerformance;

  @JsonKey(name: "disease_distribution")
  final List<DiseaseAppearanceModel> diseaseDistribution;

  @JsonKey(name: 'confidence_ranges')
  final ConfidenceRangesModel confidenceRanges;

  @JsonKey(name: "weekly_diagnoses")
  final List<DiagnoseCountModel> weeklyDiagnoses;

  @JsonKey(name: "recent_diagnoses")
  final List<DiagnoseModel> recentDiagnoses;

  @JsonKey(name: "top_diagnostics")
  final List<DiagnosticModel> topDiagnostics;

  @JsonKey(name: "upcoming_schedules")
  final List<IrrigationScheduleModel> upcomingSchedules;

  factory StatsModel.fromJson(Map<String, dynamic> json) =>
      _$StatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory StatsModel.fromString(String jsonString) {
    return StatsModel.fromJson(json.decode(jsonString));
  }
}
