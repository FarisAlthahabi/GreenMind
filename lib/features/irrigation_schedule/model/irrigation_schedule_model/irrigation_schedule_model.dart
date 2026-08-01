import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'irrigation_schedule_model.g.dart';

@JsonSerializable()
@immutable
class IrrigationScheduleModel {
  const IrrigationScheduleModel({
    required this.id,
    required this.plantId,
    required this.recommendedDate,
    this.actualDate,
    required this.isManualOverride,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
     this.plant,
  });

  final int id;

  @JsonKey(name: "plant_id")
  final int plantId;

  @JsonKey(name: "recommended_date")
  final String recommendedDate;

  @JsonKey(name: "actual_date")
  final String? actualDate;

  @JsonKey(name: "is_manual_override")
  final bool isManualOverride;

  final String? notes;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  final PlantModel? plant;

  factory IrrigationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$IrrigationScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$IrrigationScheduleModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory IrrigationScheduleModel.fromString(String jsonString) {
    return IrrigationScheduleModel.fromJson(json.decode(jsonString));
  }

  IrrigationScheduleModel copyWith({
    int? id,
    int? plantId,
    String? recommendedDate,
    String? actualDate,
    bool? isManualOverride,
    String? notes,
    String? createdAt,
    String? updatedAt,
    PlantModel? plant,
  }) {
    return IrrigationScheduleModel(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      recommendedDate: recommendedDate ?? this.recommendedDate,
      actualDate: actualDate ?? this.actualDate,
      isManualOverride: isManualOverride ?? this.isManualOverride,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plant: plant ?? this.plant,
    );
  }
}
