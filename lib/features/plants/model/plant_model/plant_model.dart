import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plant_model.g.dart';

@JsonSerializable()
@immutable
class PlantModel implements DeleteModel {
  const PlantModel({
    required this.id,
    this.userId,
    required this.cropId,
    required this.name,
    this.plantingDate,
    this.harvestDate,
    this.quantity,
    this.healthStatus,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.crop,
    this.diseaseId,
    this.disease,
  });

  final int id;

  @JsonKey(name: "user_id")
  final int? userId;

  @JsonKey(name: "crop_id")
  final int cropId;

  @JsonKey(name: "disease_id")
  final int? diseaseId;

  final String name;

  @JsonKey(name: "planting_date")
  final String? plantingDate;

  @JsonKey(name: "harvest_date")
  final String? harvestDate;

  final int? quantity;

  @JsonKey(name: "health_status")
  final String? healthStatus;

  final String? notes;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  final CropModel? crop;
  final DiseaseModel? disease;

  factory PlantModel.fromJson(Map<String, dynamic> json) =>
      _$PlantModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlantModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory PlantModel.fromString(String jsonString) {
    return PlantModel.fromJson(json.decode(jsonString));
  }

  PlantModel copyWith({
    int? id,
    int? userId,
    int? cropId,
    String? name,
    String? plantingDate,
    String? harvestDate,
    int? quantity,
    String? healthStatus,
    String? notes,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    CropModel? crop,
  }) {
    return PlantModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cropId: cropId ?? this.cropId,
      name: name ?? this.name,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      quantity: quantity ?? this.quantity,
      healthStatus: healthStatus ?? this.healthStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      crop: crop ?? this.crop,
    );
  }

  @override
  String get apiDeleteUrl => "plants/$id";
}
