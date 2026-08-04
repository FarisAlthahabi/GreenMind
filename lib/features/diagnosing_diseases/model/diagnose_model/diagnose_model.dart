import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diagnose_model.g.dart';

@JsonSerializable()
@immutable
class DiagnoseModel {
  const DiagnoseModel({
    required this.id,
    this.userId,
    this.plantId,
    required this.diseaseNameTechnical,
    required this.diseaseNameArabic,
    required this.confidencePercentage,
    required this.originalImagePath,
    required this.gradCamImagePath,
    required this.treatment,
    required this.createdAt,
    required this.updatedAt,
    this.plant,
  });

  final int id;

  @JsonKey(name: "user_id")
  final int? userId;

  @JsonKey(name: "plant_id")
  final int? plantId;

  @JsonKey(name: "disease_name_technical")
  final String diseaseNameTechnical;

  @JsonKey(name: "disease_name_arabic")
  final String diseaseNameArabic;

  @JsonKey(name: "confidence_percentage")
  final String confidencePercentage;

  @JsonKey(name: "original_image_path")
  final String originalImagePath;

  @JsonKey(name: "grad_cam_image_path")
  final String gradCamImagePath;

  final String treatment;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  final DiagnosePlantModel? plant;

  factory DiagnoseModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnoseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnoseModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnoseModel.fromString(String jsonString) {
    return DiagnoseModel.fromJson(json.decode(jsonString));
  }

  DiagnoseModel copyWith({
    int? id,
    int? userId,
    int? plantId,
    String? diseaseNameTechnical,
    String? diseaseNameArabic,
    String? confidencePercentage,
    String? originalImagePath,
    String? gradCamImagePath,
    String? treatment,
    String? createdAt,
    String? updatedAt,
    DiagnosePlantModel? plant,
  }) {
    return DiagnoseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plantId: plantId ?? this.plantId,
      diseaseNameTechnical: diseaseNameTechnical ?? this.diseaseNameTechnical,
      diseaseNameArabic: diseaseNameArabic ?? this.diseaseNameArabic,
      confidencePercentage: confidencePercentage ?? this.confidencePercentage,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      gradCamImagePath: gradCamImagePath ?? this.gradCamImagePath,
      treatment: treatment ?? this.treatment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plant: plant ?? this.plant,
    );
  }
}

@JsonSerializable()
@immutable
class DiagnosePlantModel {
  const DiagnosePlantModel({required this.id, required this.name});

  final int id;
  final String name;

  factory DiagnosePlantModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosePlantModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosePlantModelToJson(this);
}
