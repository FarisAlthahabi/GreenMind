// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confidence_ranges.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfidenceRangesModel _$ConfidenceRangesModelFromJson(
  Map<String, dynamic> json,
) => ConfidenceRangesModel(
  lessThan40: (json['less_than_40'] as num).toInt(),
  from40To59: (json['from_40_to_59'] as num).toInt(),
  from60To79: (json['from_60_to_79'] as num).toInt(),
  from80To89: (json['from_80_to_89'] as num).toInt(),
  from90To100: (json['from_90_to_100'] as num).toInt(),
);

Map<String, dynamic> _$ConfidenceRangesModelToJson(
  ConfidenceRangesModel instance,
) => <String, dynamic>{
  'less_than_40': instance.lessThan40,
  'from_40_to_59': instance.from40To59,
  'from_60_to_79': instance.from60To79,
  'from_80_to_89': instance.from80To89,
  'from_90_to_100': instance.from90To100,
};
