// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnose_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnoseCountModel _$DiagnoseCountModelFromJson(Map<String, dynamic> json) =>
    DiagnoseCountModel(
      date: json['date'] as String,
      dayName: json['day_name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$DiagnoseCountModelToJson(DiagnoseCountModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'day_name': instance.dayName,
      'count': instance.count,
    };
