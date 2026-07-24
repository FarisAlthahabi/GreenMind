import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_crop_model.g.dart';

@JsonSerializable()
@immutable
class AddCropModel {
  const AddCropModel({String? nameEn, String? nameAr, int? baseIrrigationDays})
    : _nameEn = nameEn,
      _nameAr = nameAr,
      _baseIrrigationDays = baseIrrigationDays;

  final String? _nameAr;
  final String? _nameEn;
  final int? _baseIrrigationDays;

  AddCropModel copyWith({
    String? Function()? nameEn,
    String? Function()? nameAr,
    int? Function()? baseIrrigationDays,
  }) {
    return AddCropModel(
      nameEn: nameEn != null ? nameEn() : _nameEn,
      nameAr: nameAr != null ? nameAr() : _nameAr,
      baseIrrigationDays: baseIrrigationDays != null
          ? baseIrrigationDays()
          : _baseIrrigationDays,
    );
  }

  @JsonKey(name: "name_en")
  String get nameEn {
    if (_nameEn == null || _nameEn.isEmpty) {
      throw "name_en_required".tr();
    }
    return _nameEn;
  }

  @JsonKey(name: "name_ar")
  String get nameAr {
    if (_nameAr == null || _nameAr.isEmpty) {
      throw "name_ar_required".tr();
    }
    return _nameAr;
  }

  @JsonKey(name: "base_irrigation_days")
  int get baseIrrigationDays {
    return _baseIrrigationDays ?? (throw "irrigation_days_required".tr());
  }

  Map<String, dynamic> toJson() => _$AddCropModelToJson(this);

  factory AddCropModel.fromJson(Map<String, dynamic> json) =>
      _$AddCropModelFromJson(json);
}
