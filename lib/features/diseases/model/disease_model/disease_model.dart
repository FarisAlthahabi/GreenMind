import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'disease_model.g.dart';

@JsonSerializable()
@immutable
class DiseaseModel implements DeleteModel, DropDownItemModel {
  const DiseaseModel({
    required this.id,
    required this.technicalName,
    required this.arName,
    required this.enName,
    this.createdAt,
    this.updatedAt,
  });

  @override
  final int id;

  @JsonKey(name: "technical_name")
  final String technicalName;

  @JsonKey(name: "ar_name")
  final String arName;

  @JsonKey(name: "en_name")
  final String enName;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  factory DiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$DiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiseaseModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiseaseModel.fromString(String jsonString) {
    return DiseaseModel.fromJson(json.decode(jsonString));
  }

  DiseaseModel copyWith({
    int? id,
    String? technicalName,
    String? arName,
    String? enName,
    String? createdAt,
    String? updatedAt,
  }) {
    return DiseaseModel(
      id: id ?? this.id,
      technicalName: technicalName ?? this.technicalName,
      arName: arName ?? this.arName,
      enName: enName ?? this.enName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String get apiDeleteUrl => "diseases/$id";

  @override
  String? get description => null;

  @override
  String get displayName => enName;

  @override
  List<Object?> get props => [
    id,
    technicalName,
    arName,
    enName,
    createdAt,
    updatedAt,
  ];

  @override
  bool? get stringify => null;
}
