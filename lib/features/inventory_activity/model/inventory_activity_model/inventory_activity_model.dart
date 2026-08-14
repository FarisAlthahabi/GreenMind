import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/features/inventory/model/inventory_model/inventory_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_activity_model.g.dart';

@JsonSerializable()
@immutable
class InventoryActivityModel extends Equatable {
  const InventoryActivityModel({
    required this.id,
    required this.harvestedInventoryId,
    required this.userId,
    required this.quantityUsed,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    this.inventory,
    this.user,
  });

  final int id;

  @JsonKey(name: "harvested_inventory_id")
  final int harvestedInventoryId;

  @JsonKey(name: "user_id")
  final int userId;

  @JsonKey(name: "quantity_used")
  final int quantityUsed;

  final String reason;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "updated_at")
  final String updatedAt;

  final InventoryModel? inventory;
  final ActivityUserModel? user;

  factory InventoryActivityModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryActivityModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory InventoryActivityModel.fromString(String jsonString) {
    return InventoryActivityModel.fromJson(json.decode(jsonString));
  }

  InventoryActivityModel copyWith({
    int? id,
    int? harvestedInventoryId,
    int? userId,
    int? quantityUsed,
    String? reason,
    String? createdAt,
    String? updatedAt,
    InventoryModel? inventory,
    ActivityUserModel? user,
  }) {
    return InventoryActivityModel(
      id: id ?? this.id,
      harvestedInventoryId: harvestedInventoryId ?? this.harvestedInventoryId,
      userId: userId ?? this.userId,
      quantityUsed: quantityUsed ?? this.quantityUsed,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      inventory: inventory ?? this.inventory,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    id,
    harvestedInventoryId,
    userId,
    quantityUsed,
    reason,
    createdAt,
    updatedAt,
    inventory,
    user,
  ];
}

@JsonSerializable()
@immutable
class ActivityUserModel {
  const ActivityUserModel({required this.id, required this.name});

  final int id;
  final String name;

  factory ActivityUserModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityUserModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory ActivityUserModel.fromString(String jsonString) {
    return ActivityUserModel.fromJson(json.decode(jsonString));
  }
}
