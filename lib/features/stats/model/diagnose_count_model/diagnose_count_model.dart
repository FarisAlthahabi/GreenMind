import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnose_count_model.g.dart';

@JsonSerializable()
@immutable
class DiagnoseCountModel {
  const DiagnoseCountModel({
    required this.date,
    required this.dayName,
    required this.count,
  });

  final String date;

  @JsonKey(name: "day_name")
  final String dayName;

  final int count;

  factory DiagnoseCountModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnoseCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnoseCountModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnoseCountModel.fromString(String jsonString) {
    return DiagnoseCountModel.fromJson(json.decode(jsonString));
  }

  DiagnoseCountModel copyWith({
    String? date,
    String? dayName,
    int? count,
  }) {
    return DiagnoseCountModel(
      date: date ?? this.date,
      dayName: dayName ?? this.dayName,
      count: count ?? this.count,
    );
  }
}