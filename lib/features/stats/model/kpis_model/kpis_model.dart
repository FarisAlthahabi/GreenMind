import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kpis_model.g.dart';

@JsonSerializable()
@immutable
class KpisModel {
  const KpisModel({
    required this.totalPlants,
    required this.healthyPlants,
    required this.diseasedPlants,
    required this.totalQuantity,
  });

  @JsonKey(name: "total_plants")
  final int totalPlants;

  @JsonKey(name: "healthy_plants")
  final int healthyPlants;

  @JsonKey(name: "diseased_plants")
  final int diseasedPlants;

  @JsonKey(name: "total_quantity")
  final int totalQuantity;

  factory KpisModel.fromJson(Map<String, dynamic> json) =>
      _$KpisModelFromJson(json);

  Map<String, dynamic> toJson() => _$KpisModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory KpisModel.fromString(String jsonString) {
    return KpisModel.fromJson(json.decode(jsonString));
  }

  KpisModel copyWith({
    int? totalPlants,
    int? healthyPlants,
    int? diseasedPlants,
    int? totalQuantity,
  }) {
    return KpisModel(
      totalPlants: totalPlants ?? this.totalPlants,
      healthyPlants: healthyPlants ?? this.healthyPlants,
      diseasedPlants: diseasedPlants ?? this.diseasedPlants,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}