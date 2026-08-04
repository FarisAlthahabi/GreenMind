// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      totalUsers: (json['total_users'] as num).toInt(),
      engineersCount: (json['engineers_count'] as num).toInt(),
      farmersCount: (json['farmers_count'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'engineers_count': instance.engineersCount,
      'farmers_count': instance.farmersCount,
    };
