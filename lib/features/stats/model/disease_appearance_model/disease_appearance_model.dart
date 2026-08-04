import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'disease_appearance_model.g.dart';

@JsonSerializable()
@immutable
class DiseaseAppearanceModel {
  const DiseaseAppearanceModel({required this.name, required this.count});

  final String name;
  final int count;

  factory DiseaseAppearanceModel.fromJson(Map<String, dynamic> json) =>
      _$DiseaseAppearanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiseaseAppearanceModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DiseaseAppearanceModel.fromString(String jsonString) {
    return DiseaseAppearanceModel.fromJson(json.decode(jsonString));
  }

  DiseaseAppearanceModel copyWith({String? name, int? count}) {
    return DiseaseAppearanceModel(
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }
}
