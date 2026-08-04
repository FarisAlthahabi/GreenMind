import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_disease_model.g.dart';

@JsonSerializable()
@immutable
class AddDiseaseModel {
  const AddDiseaseModel({
    String? technicalName,
    String? enName,
    String? arName,
  })  : _technicalName = technicalName,
        _enName = enName,
        _arName = arName;

  final String? _technicalName;
  final String? _enName;
  final String? _arName;

  AddDiseaseModel copyWith({
    String? Function()? technicalName,
    String? Function()? enName,
    String? Function()? arName,
  }) {
    return AddDiseaseModel(
      technicalName: technicalName != null ? technicalName() : _technicalName,
      enName: enName != null ? enName() : _enName,
      arName: arName != null ? arName() : _arName,
    );
  }

  @JsonKey(name: "technical_name")
  String get technicalName {
    if (_technicalName == null || _technicalName.isEmpty) {
      throw "technical_name_required".tr();
    }
    return _technicalName;
  }

  @JsonKey(name: "en_name")
  String get enName {
    if (_enName == null || _enName.isEmpty) {
      throw "en_name_required".tr();
    }
    return _enName;
  }

  @JsonKey(name: "ar_name")
  String get arName {
    if (_arName == null || _arName.isEmpty) {
      throw "ar_name_required".tr();
    }
    return _arName;
  }

  Map<String, dynamic> toJson() => _$AddDiseaseModelToJson(this);

  factory AddDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$AddDiseaseModelFromJson(json);
}