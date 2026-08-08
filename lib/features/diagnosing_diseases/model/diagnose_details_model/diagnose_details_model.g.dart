// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnose_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnoseDetailsModel _$DiagnoseDetailsModelFromJson(
  Map<String, dynamic> json,
) => DiagnoseDetailsModel(
  localName: json['local_name'] as String,
  symptoms: json['symptoms'] as String,
  syrianRemedy: json['syrian_remedy'] as String,
  organicAdvice: json['organic_advice'] as String,
  localTiming: json['local_timing'] as String,
  officialSource: json['official_source'] as String,
);

Map<String, dynamic> _$DiagnoseDetailsModelToJson(
  DiagnoseDetailsModel instance,
) => <String, dynamic>{
  'local_name': instance.localName,
  'symptoms': instance.symptoms,
  'syrian_remedy': instance.syrianRemedy,
  'organic_advice': instance.organicAdvice,
  'local_timing': instance.localTiming,
  'official_source': instance.officialSource,
};
