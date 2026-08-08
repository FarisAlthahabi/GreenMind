import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnose_details_model.g.dart';

@JsonSerializable()
@immutable
class DiagnoseDetailsModel {
  const DiagnoseDetailsModel({
    required this.localName,
    required this.symptoms,
    required this.syrianRemedy,
    required this.organicAdvice,
    required this.localTiming,
    required this.officialSource,
  });

  @JsonKey(name: "local_name")
  final String localName;

  final String symptoms;

  @JsonKey(name: "syrian_remedy")
  final String syrianRemedy;

  @JsonKey(name: "organic_advice")
  final String organicAdvice;

  @JsonKey(name: "local_timing")
  final String localTiming;

  @JsonKey(name: "official_source")
  final String officialSource;

  factory DiagnoseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnoseDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnoseDetailsModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnoseDetailsModel.fromString(String jsonString) {
    return DiagnoseDetailsModel.fromJson(json.decode(jsonString));
  }

  DiagnoseDetailsModel copyWith({
    String? localName,
    String? symptoms,
    String? syrianRemedy,
    String? organicAdvice,
    String? localTiming,
    String? officialSource,
  }) {
    return DiagnoseDetailsModel(
      localName: localName ?? this.localName,
      symptoms: symptoms ?? this.symptoms,
      syrianRemedy: syrianRemedy ?? this.syrianRemedy,
      organicAdvice: organicAdvice ?? this.organicAdvice,
      localTiming: localTiming ?? this.localTiming,
      officialSource: officialSource ?? this.officialSource,
    );
  }
}