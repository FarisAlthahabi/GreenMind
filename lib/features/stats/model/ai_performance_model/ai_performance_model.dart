import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_performance_model.g.dart';

@JsonSerializable()
@immutable
class AiPerformanceModel {
  const AiPerformanceModel({
    required this.totalDiagnoses,
    required this.avgConfidence,
  });

  @JsonKey(name: "total_diagnoses")
  final int totalDiagnoses;

  @JsonKey(name: "avg_confidence")
  final double avgConfidence;

  factory AiPerformanceModel.fromJson(Map<String, dynamic> json) =>
      _$AiPerformanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiPerformanceModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AiPerformanceModel.fromString(String jsonString) {
    return AiPerformanceModel.fromJson(json.decode(jsonString));
  }

  AiPerformanceModel copyWith({
    int? totalDiagnoses,
    double? avgConfidence,
  }) {
    return AiPerformanceModel(
      totalDiagnoses: totalDiagnoses ?? this.totalDiagnoses,
      avgConfidence: avgConfidence ?? this.avgConfidence,
    );
  }
}