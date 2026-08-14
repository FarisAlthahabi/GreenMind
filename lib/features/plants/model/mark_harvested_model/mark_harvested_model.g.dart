// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_harvested_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkHarvestedModel _$MarkHarvestedModelFromJson(Map<String, dynamic> json) =>
    MarkHarvestedModel(
      harvestQuantity: (json['harvest_quantity'] as num?)?.toInt(),
      storageLocation: json['storage_location'] as String?,
    );

Map<String, dynamic> _$MarkHarvestedModelToJson(MarkHarvestedModel instance) =>
    <String, dynamic>{
      'harvest_quantity': instance.harvestQuantity,
      'storage_location': instance.storageLocation,
    };
