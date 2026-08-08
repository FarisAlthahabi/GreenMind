import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_plant_model.g.dart';

@JsonSerializable()
@immutable
class AddPlantModel {
  const AddPlantModel({
    int? cropId,
    String? name,
    String? plantingDate,
    String? harvestDate,
    int? quantity,
    int? diseaseId,
    // String? healthStatus,
    String? notes,
  }) : _cropId = cropId,
       _name = name,
       _plantingDate = plantingDate,
       _harvestDate = harvestDate,
       _quantity = quantity,
       _diseaseId = diseaseId,
       //  _healthStatus = healthStatus,
       _notes = notes;

  final int? _cropId;
  final String? _name;
  final String? _plantingDate;
  final String? _harvestDate;
  final int? _quantity;
  final int? _diseaseId;
  // final String? _healthStatus;
  final String? _notes;

  AddPlantModel copyWith({
    int? Function()? cropId,
    String? Function()? name,
    String? Function()? plantingDate,
    String? Function()? harvestDate,
    int? Function()? quantity,
    int? Function()? diseaseId,
    // String? Function()? healthStatus,
    String? Function()? notes,
  }) {
    return AddPlantModel(
      cropId: cropId != null ? cropId() : _cropId,
      name: name != null ? name() : _name,
      plantingDate: plantingDate != null ? plantingDate() : _plantingDate,
      harvestDate: harvestDate != null ? harvestDate() : _harvestDate,
      quantity: quantity != null ? quantity() : _quantity,
      diseaseId: diseaseId != null ? diseaseId() : _diseaseId,
      // healthStatus: healthStatus != null ? healthStatus() : _healthStatus,
      notes: notes != null ? notes() : _notes,
    );
  }

  @JsonKey(name: "crop_id")
  int get cropId {
    return _cropId ?? (throw "crop_id_required".tr());
  }

  @JsonKey(name: "name")
  String get name {
    if (_name == null || _name.isEmpty) {
      throw "name_required".tr();
    }
    return _name;
  }

  @JsonKey(name: "planting_date")
  String get plantingDate {
    if (_plantingDate == null || _plantingDate.isEmpty) {
      throw "planting_date_required".tr();
    }
    return _plantingDate;
  }

  @JsonKey(name: "harvest_date")
  String? get harvestDate {
    return _harvestDate;
  }

  // @JsonKey(name: "health_status")
  // String? get healthStatus {
  //   return _healthStatus;
  // }

  @JsonKey(name: "disease_id")
  int? get diseaseId {
    return _diseaseId;
  }

  @JsonKey(name: "quantity")
  int get quantity {
    return _quantity ?? (throw "quantity_required".tr());
  }

  @JsonKey(name: "notes")
  String? get notes => _notes;

  Map<String, dynamic> toJson() => _$AddPlantModelToJson(this);

  factory AddPlantModel.fromJson(Map<String, dynamic> json) =>
      _$AddPlantModelFromJson(json);
}
