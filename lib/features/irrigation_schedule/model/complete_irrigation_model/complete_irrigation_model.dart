import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complete_irrigation_model.g.dart';

@JsonSerializable()
@immutable
class CompleteIrrigationModel {
  const CompleteIrrigationModel({
    required this.completedSchedule,
    required this.nextSchedule,
  });

  @JsonKey(name: "completed_schedule")
  final IrrigationScheduleModel completedSchedule;

  @JsonKey(name: "next_schedule")
  final IrrigationScheduleModel nextSchedule;

  factory CompleteIrrigationModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteIrrigationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteIrrigationModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CompleteIrrigationModel.fromString(String jsonString) {
    return CompleteIrrigationModel.fromJson(json.decode(jsonString));
  }
}
