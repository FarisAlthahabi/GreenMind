import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
@immutable
class InventoryModel implements DropDownItemModel {
  const InventoryModel({
    required this.id,
    required this.plantId,
    required this.harvestQuantity,
    required this.currentQuantity,
    required this.storageLocation,
    required this.createdAt,
    required this.updatedAt,
    this.plant,
  });

  @override
  final int id;

  @JsonKey(name: "plant_id")
  final int plantId;

  @JsonKey(name: "harvest_quantity")
  final int harvestQuantity;

  @JsonKey(name: "current_quantity")
  final int currentQuantity;

  @JsonKey(name: "storage_location")
  final String storageLocation;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  final PlantInventoryModel? plant;

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory InventoryModel.fromString(String jsonString) {
    return InventoryModel.fromJson(json.decode(jsonString));
  }

  InventoryModel copyWith({
    int? id,
    int? plantId,
    int? harvestQuantity,
    int? currentQuantity,
    String? storageLocation,
    String? createdAt,
    String? updatedAt,
    PlantInventoryModel? plant,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      harvestQuantity: harvestQuantity ?? this.harvestQuantity,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      storageLocation: storageLocation ?? this.storageLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      plant: plant ?? this.plant,
    );
  }

  @override
  String? get description => null;

  @override
  String get displayName => plant?.name ?? "Inventory #$id";

  @override
  List<Object?> get props => [
    id,
    plantId,
    harvestQuantity,
    currentQuantity,
    storageLocation,
    createdAt,
    updatedAt,
    plant,
  ];

  @override
  bool? get stringify => null;
}

@JsonSerializable()
@immutable
class PlantInventoryModel extends Equatable {
  const PlantInventoryModel({
    required this.id,
    required this.name,
    this.cropId,
    this.crop,
  });

  final int id;
  final String name;

  @JsonKey(name: "crop_id")
  final int? cropId;

  final CropInventoryModel? crop;

  factory PlantInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$PlantInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlantInventoryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory PlantInventoryModel.fromString(String jsonString) {
    return PlantInventoryModel.fromJson(json.decode(jsonString));
  }

  PlantInventoryModel copyWith({
    int? id,
    String? name,
    int? cropId,
    CropInventoryModel? crop,
  }) {
    return PlantInventoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cropId: cropId ?? this.cropId,
      crop: crop ?? this.crop,
    );
  }

  @override
  List<Object?> get props => [id, name, cropId, crop];

  @override
  bool? get stringify => null;
}

@JsonSerializable()
@immutable
class CropInventoryModel implements DropDownItemModel {
  const CropInventoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  @override
  final int id;

  @JsonKey(name: "name_ar")
  final String nameAr;

  @JsonKey(name: "name_en")
  final String nameEn;

  factory CropInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$CropInventoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CropInventoryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CropInventoryModel.fromString(String jsonString) {
    return CropInventoryModel.fromJson(json.decode(jsonString));
  }

  CropInventoryModel copyWith({int? id, String? nameAr, String? nameEn}) {
    return CropInventoryModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  @override
  String? get description => null;

  @override
  String get displayName => nameEn;

  @override
  List<Object?> get props => [id, nameAr, nameEn];

  @override
  bool? get stringify => null;
}
