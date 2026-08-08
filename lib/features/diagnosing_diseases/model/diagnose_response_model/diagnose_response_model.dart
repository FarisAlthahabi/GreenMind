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
    required this.recommendedIntervalDays,
    this.details,
  });

  final DiagnoseModel diagnosis;

  @JsonKey(name: "recommended_interval_days")
  final int recommendedIntervalDays;

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
    int? recommendedIntervalDays,
    DiagnoseDetailsModel? details,
  }) {
    return DiagnoseResponseModel(
      diagnosis: diagnosis ?? this.diagnosis,
      recommendedIntervalDays: recommendedIntervalDays ?? this.recommendedIntervalDays,
      details: details ?? this.details,
    );
  }
}