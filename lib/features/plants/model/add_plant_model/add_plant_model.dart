import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_plant_model.g.dart';

@JsonSerializable(includeIfNull: false)
@immutable
class AddPlantModel {
  const AddPlantModel({
    int? cropId,
    String? name,
    String? plantingDate,
    String? harvestDate,
    int? baseIrrigationDays,
    int? quantity,
    int? diseaseId,
    // String? healthStatus,
    String? notes,
    this.isAdd = true,
  }) : _cropId = cropId,
       _name = name,
       _plantingDate = plantingDate,
       _harvestDate = harvestDate,
       _baseIrrigationDays = baseIrrigationDays,
       _quantity = quantity,
       _diseaseId = diseaseId,
       //  _healthStatus = healthStatus,
       _notes = notes;

  final int? _cropId;
  final String? _name;
  final String? _plantingDate;
  final String? _harvestDate;
  final int? _baseIrrigationDays;
  final int? _quantity;
  final int? _diseaseId;
  // final String? _healthStatus;
  final String? _notes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isAdd;

  AddPlantModel copyWith({
    int? Function()? cropId,
    String? Function()? name,
    String? Function()? plantingDate,
    String? Function()? harvestDate,
    int? Function()? baseIrrigationDays,
    int? Function()? quantity,
    int? Function()? diseaseId,
    // String? Function()? healthStatus,
    String? Function()? notes,

    bool? isAdd,
  }) {
    return AddPlantModel(
      cropId: cropId != null ? cropId() : _cropId,
      name: name != null ? name() : _name,
      plantingDate: plantingDate != null ? plantingDate() : _plantingDate,
      harvestDate: harvestDate != null ? harvestDate() : _harvestDate,
      baseIrrigationDays: baseIrrigationDays != null
          ? baseIrrigationDays()
          : _baseIrrigationDays,
      quantity: quantity != null ? quantity() : _quantity,
      diseaseId: diseaseId != null ? diseaseId() : _diseaseId,
      // healthStatus: healthStatus != null ? healthStatus() : _healthStatus,
      notes: notes != null ? notes() : _notes,
      isAdd: isAdd ?? this.isAdd,
    );
  }

  @JsonKey(name: "crop_id")
  int? get cropId {
    if (isAdd) {
      return _cropId ?? (throw "crop_id_required".tr());
    }
    return _cropId;
  }

  @JsonKey(name: "name")
  String? get name {
    if (isAdd && (_name == null || _name.isEmpty)) {
      throw "name_required".tr();
    }
    return _name;
  }

  @JsonKey(name: "planting_date")
  String? get plantingDate {
    if (isAdd && (_plantingDate == null || _plantingDate.isEmpty)) {
      throw "planting_date_required".tr();
    }
    return _plantingDate;
  }

  @JsonKey(name: "harvest_date")
  String? get harvestDate {
    return _harvestDate;
  }

  @JsonKey(name: "base_irrigation_days")
  int? get baseIrrigationDays {
    return _baseIrrigationDays;
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
  int? get quantity {
    if (isAdd) {
      return _quantity ?? (throw "quantity_required".tr());
    }
    return _quantity;
  }

  @JsonKey(name: "notes")
  String? get notes => _notes;

  Map<String, dynamic> toJson() => _$AddPlantModelToJson(this);

  factory AddPlantModel.fromJson(Map<String, dynamic> json) =>
      _$AddPlantModelFromJson(json);
}
