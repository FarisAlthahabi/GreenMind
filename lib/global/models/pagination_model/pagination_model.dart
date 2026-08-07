import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
@immutable
class PaginationModel {
  const PaginationModel({
    required this.total,
    required this.lastPage,
    required this.perPage,
    required this.currentPage,
    this.from,
    this.to,
  });

  final int total;

  @JsonKey(name: "last_page")
  final int lastPage;

  @JsonKey(name: "per_page")
  final int perPage;

  @JsonKey(name: "current_page")
  final int currentPage;

  final int? from;
  final int? to;

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory PaginationModel.fromString(String jsonString) {
    return PaginationModel.fromJson(json.decode(jsonString));
  }
}
