import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_mind/global/utils/json_converters/string_converter.dart';
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

  @StringConverter()
  @JsonKey(name: "less_than_40")
  final String lessThan40;

  @StringConverter()
  @JsonKey(name: "from_40_to_59")
  final String from40To59;

  @StringConverter()
  @JsonKey(name: "from_60_to_79")
  final String from60To79;

  @StringConverter()
  @JsonKey(name: "from_80_to_89")
  final String from80To89;

  @StringConverter()
  @JsonKey(name: "from_90_to_100")
  final String from90To100;

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
    String? lessThan40,
    String? from40To59,
    String? from60To79,
    String? from80To89,
    String? from90To100,
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