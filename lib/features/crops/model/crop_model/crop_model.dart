import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crop_model.g.dart';

@JsonSerializable()
@immutable
class CropModel implements DeleteModel, DropDownItemModel {
  const CropModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.baseIrrigationDays,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final int id;

  @JsonKey(name: "name_ar")
  final String nameAr;

  @JsonKey(name: "name_en")
  final String nameEn;

  @JsonKey(name: "base_irrigation_days")
  final int? baseIrrigationDays;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  factory CropModel.fromJson(Map<String, dynamic> json) =>
      _$CropModelFromJson(json);

  Map<String, dynamic> toJson() => _$CropModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CropModel.fromString(String jsonString) {
    return CropModel.fromJson(json.decode(jsonString));
  }

  CropModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    int? baseIrrigationDays,
    String? createdAt,
    String? updatedAt,
  }) {
    return CropModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      baseIrrigationDays: baseIrrigationDays ?? this.baseIrrigationDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String get apiDeleteUrl => "crops/$id";

  @override
  String? get description => null;

  @override
  String get displayName => nameEn;

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    baseIrrigationDays,
    createdAt,
    updatedAt,
  ];

  @override
  bool? get stringify => null;
}