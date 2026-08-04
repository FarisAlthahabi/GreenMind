// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_appearance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiseaseAppearanceModel _$DiseaseAppearanceModelFromJson(
  Map<String, dynamic> json,
) => DiseaseAppearanceModel(
  name: json['name'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$DiseaseAppearanceModelToJson(
  DiseaseAppearanceModel instance,
) => <String, dynamic>{'name': instance.name, 'count': instance.count};
