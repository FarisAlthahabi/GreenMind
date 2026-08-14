import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_details_model/diagnose_details_model.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnose_response_model.g.dart';

@JsonSerializable()
@immutable
class DiagnoseResponseModel {
  const DiagnoseResponseModel({
    required this.diagnosis,
    required this.recommendation,
    this.details,
  });

  final DiagnoseModel diagnosis;

  @JsonKey(name: "schedule_recommendation")
  final ScheduleRecommendationModel recommendation;

  final DiagnoseDetailsModel? details;

  factory DiagnoseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnoseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnoseResponseModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnoseResponseModel.fromString(String jsonString) {
    return DiagnoseResponseModel.fromJson(json.decode(jsonString));
  }

  DiagnoseResponseModel copyWith({
    DiagnoseModel? diagnosis,
    ScheduleRecommendationModel? recommendation,
    DiagnoseDetailsModel? details,
  }) {
    return DiagnoseResponseModel(
      diagnosis: diagnosis ?? this.diagnosis,
      recommendation: recommendation ?? this.recommendation,
      details: details ?? this.details,
    );
  }
}

@JsonSerializable()
@immutable
class ScheduleRecommendationModel {
  const ScheduleRecommendationModel({
    required this.intervalDays,
    required this.reason,
  });

  @JsonKey(name: "recommended_interval_days")
  final int intervalDays;

  final String reason;

  factory ScheduleRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleRecommendationModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory ScheduleRecommendationModel.fromString(String jsonString) {
    return ScheduleRecommendationModel.fromJson(json.decode(jsonString));
  }
}
