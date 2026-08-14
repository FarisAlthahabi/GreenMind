// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispatch_inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DispatchInventoryModel _$DispatchInventoryModelFromJson(
  Map<String, dynamic> json,
) => DispatchInventoryModel(
  quantityUsed: (json['quantity_used'] as num?)?.toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DispatchInventoryModelToJson(
  DispatchInventoryModel instance,
) => <String, dynamic>{
  'quantity_used': instance.quantityUsed,
  'reason': instance.reason,
};
