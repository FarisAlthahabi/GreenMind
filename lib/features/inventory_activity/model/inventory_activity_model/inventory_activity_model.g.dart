// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryActivityModel _$InventoryActivityModelFromJson(
  Map<String, dynamic> json,
) => InventoryActivityModel(
  id: (json['id'] as num).toInt(),
  harvestedInventoryId: (json['harvested_inventory_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  quantityUsed: (json['quantity_used'] as num).toInt(),
  reason: json['reason'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  inventory: json['inventory'] == null
      ? null
      : InventoryModel.fromJson(json['inventory'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : ActivityUserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InventoryActivityModelToJson(
  InventoryActivityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'harvested_inventory_id': instance.harvestedInventoryId,
  'user_id': instance.userId,
  'quantity_used': instance.quantityUsed,
  'reason': instance.reason,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'inventory': instance.inventory,
  'user': instance.user,
};

ActivityUserModel _$ActivityUserModelFromJson(Map<String, dynamic> json) =>
    ActivityUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ActivityUserModelToJson(ActivityUserModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
