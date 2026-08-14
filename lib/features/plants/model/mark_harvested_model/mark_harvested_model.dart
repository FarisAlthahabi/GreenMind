import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'mark_harvested_model.g.dart';

@JsonSerializable()
@immutable
class MarkHarvestedModel {
  const MarkHarvestedModel({int? harvestQuantity, String? storageLocation})
    : _harvestQuantity = harvestQuantity,
      _storageLocation = storageLocation;

  final int? _harvestQuantity;
  final String? _storageLocation;

  MarkHarvestedModel copyWith({
    int? Function()? harvestQuantity,
    String? Function()? storageLocation,
  }) {
    return MarkHarvestedModel(
      harvestQuantity: harvestQuantity != null
          ? harvestQuantity()
          : _harvestQuantity,
      storageLocation: storageLocation != null
          ? storageLocation()
          : _storageLocation,
    );
  }

  @JsonKey(name: "harvest_quantity")
  int get harvestQuantity {
    return _harvestQuantity ?? (throw "harvest_quantity_required".tr());
  }

  @JsonKey(name: "storage_location")
  String get storageLocation {
    if (_storageLocation == null || _storageLocation.isEmpty) {
      throw "storage_location_required".tr();
    }
    return _storageLocation;
  }

  Map<String, dynamic> toJson() => _$MarkHarvestedModelToJson(this);

  factory MarkHarvestedModel.fromJson(Map<String, dynamic> json) =>
      _$MarkHarvestedModelFromJson(json);
}
