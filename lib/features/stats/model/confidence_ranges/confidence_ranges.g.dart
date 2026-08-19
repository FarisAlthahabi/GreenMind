// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confidence_ranges.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfidenceRangesModel _$ConfidenceRangesModelFromJson(
  Map<String, dynamic> json,
) => ConfidenceRangesModel(
  lessThan40: const StringConverter().fromJson(json['less_than_40']),
  from40To59: const StringConverter().fromJson(json['from_40_to_59']),
  from60To79: const StringConverter().fromJson(json['from_60_to_79']),
  from80To89: const StringConverter().fromJson(json['from_80_to_89']),
  from90To100: const StringConverter().fromJson(json['from_90_to_100']),
);

Map<String, dynamic> _$ConfidenceRangesModelToJson(
  ConfidenceRangesModel instance,
) => <String, dynamic>{
  'less_than_40': const StringConverter().toJson(instance.lessThan40),
  'from_40_to_59': const StringConverter().toJson(instance.from40To59),
  'from_60_to_79': const StringConverter().toJson(instance.from60To79),
  'from_80_to_89': const StringConverter().toJson(instance.from80To89),
  'from_90_to_100': const StringConverter().toJson(instance.from90To100),
};
