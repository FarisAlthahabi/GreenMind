import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'confidence_ranges.g.dart';

@JsonSerializable()
@immutable
class ConfidenceRangesModel {
  const ConfidenceRangesModel({
    required this.lessThan40,
    required this.from40To59,
    required this.from60To79,
    required this.from80To89,
    required this.from90To100,
  });

  @JsonKey(name: "less_than_40")
  final int lessThan40;

  @JsonKey(name: "from_40_to_59")
  final int from40To59;

  @JsonKey(name: "from_60_to_79")
  final int from60To79;

  @JsonKey(name: "from_80_to_89")
  final int from80To89;

  @JsonKey(name: "from_90_to_100")
  final int from90To100;

  factory ConfidenceRangesModel.fromJson(Map<String, dynamic> json) =>
      _$ConfidenceRangesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfidenceRangesModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory ConfidenceRangesModel.fromString(String jsonString) {
    return ConfidenceRangesModel.fromJson(json.decode(jsonString));
  }

  ConfidenceRangesModel copyWith({
    int? lessThan40,
    int? from40To59,
    int? from60To79,
    int? from80To89,
    int? from90To100,
  }) {
    return ConfidenceRangesModel(
      lessThan40: lessThan40 ?? this.lessThan40,
      from40To59: from40To59 ?? this.from40To59,
      from60To79: from60To79 ?? this.from60To79,
      from80To89: from80To89 ?? this.from80To89,
      from90To100: from90To100 ?? this.from90To100,
    );
  }
}