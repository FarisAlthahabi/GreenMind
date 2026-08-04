import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_stats_model.g.dart';

@JsonSerializable()
@immutable
class UserStatsModel {
  const UserStatsModel({
    required this.totalUsers,
    required this.engineersCount,
    required this.farmersCount,
  });

  @JsonKey(name: "total_users")
  final int totalUsers;

  @JsonKey(name: "engineers_count")
  final int engineersCount;

  @JsonKey(name: "farmers_count")
  final int farmersCount;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UserStatsModel.fromString(String jsonString) {
    return UserStatsModel.fromJson(json.decode(jsonString));
  }

  UserStatsModel copyWith({
    int? totalUsers,
    int? engineersCount,
    int? farmersCount,
  }) {
    return UserStatsModel(
      totalUsers: totalUsers ?? this.totalUsers,
      engineersCount: engineersCount ?? this.engineersCount,
      farmersCount: farmersCount ?? this.farmersCount,
    );
  }
}