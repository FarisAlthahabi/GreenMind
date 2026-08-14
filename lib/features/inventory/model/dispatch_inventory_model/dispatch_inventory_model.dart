import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'dispatch_inventory_model.g.dart';

@JsonSerializable()
@immutable
class DispatchInventoryModel {
  const DispatchInventoryModel({int? quantityUsed, String? reason})
    : _quantityUsed = quantityUsed,
      _reason = reason;

  final int? _quantityUsed;
  final String? _reason;

  DispatchInventoryModel copyWith({
    int? Function()? quantityUsed,
    String? Function()? reason,
  }) {
    return DispatchInventoryModel(
      quantityUsed: quantityUsed != null ? quantityUsed() : _quantityUsed,
      reason: reason != null ? reason() : _reason,
    );
  }

  @JsonKey(name: "quantity_used")
  int get quantityUsed {
    return _quantityUsed ?? (throw "quantity_used_required".tr());
  }

  String get reason {
    if (_reason == null || _reason.isEmpty) {
      throw "reason_required".tr();
    }
    return _reason;
  }

  Map<String, dynamic> toJson() => _$DispatchInventoryModelToJson(this);

  factory DispatchInventoryModel.fromJson(Map<String, dynamic> json) =>
      _$DispatchInventoryModelFromJson(json);
}
