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
    required this.nameTechnical,
    required this.nameEn,
    required this.nameAr,
    required this.confidencePercentage,
    required this.originalImagePath,
    required this.gradCamImagePath,
    required this.treatment,
    required this.createdAt,
    required this.updatedAt,
    this.plant,
    this.user,
  });

  final int id;

  @JsonKey(name: "user_id")
  final int? userId;

  @JsonKey(name: "plant_id")
  final int? plantId;

  @JsonKey(name: "disease_name_technical")
  final String nameTechnical;

  @JsonKey(name: "disease_name_english")
  final String nameEn;

  @JsonKey(name: "disease_name_arabic")
  final String nameAr;

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
  final DiagnosePlantModel? user;

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
    String? nameTechnical,
    String? nameEn,
    String? nameAr,
    String? confidencePercentage,
    String? originalImagePath,
    String? gradCamImagePath,
    String? treatment,
    String? createdAt,
    String? updatedAt,
    DiagnosePlantModel? plant,
    DiagnosePlantModel? user,
  }) {
    return DiagnoseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plantId: plantId ?? this.plantId,
      nameTechnical: nameTechnical ?? this.nameTechnical,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      confidencePercentage: confidencePercentage ?? this.confidencePercentage,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      gradCamImagePath: gradCamImagePath ?? this.gradCamImagePath,
      treatment: treatment ?? this.treatment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plant: plant ?? this.plant,
      user: user ?? this.user,
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

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiagnosePlantModel.fromString(String jsonString) {
    return DiagnosePlantModel.fromJson(json.decode(jsonString));
  }
}
