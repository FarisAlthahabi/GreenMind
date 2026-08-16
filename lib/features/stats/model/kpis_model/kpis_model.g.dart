// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KpisModel _$KpisModelFromJson(Map<String, dynamic> json) => KpisModel(
  totalPlants: (json['total_plants'] as num).toInt(),
  healthyPlants: (json['healthy_plants'] as num).toInt(),
  diseasedPlants: (json['diseased_plants'] as num).toInt(),
  totalQuantity: const StringConverter().fromJson(json['total_quantity']),
);

Map<String, dynamic> _$KpisModelToJson(KpisModel instance) => <String, dynamic>{
  'total_plants': instance.totalPlants,
  'healthy_plants': instance.healthyPlants,
  'diseased_plants': instance.diseasedPlants,
  'total_quantity': const StringConverter().toJson(instance.totalQuantity),
};
