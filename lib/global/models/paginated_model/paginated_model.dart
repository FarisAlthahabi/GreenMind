import 'dart:convert';

import 'package:green_mind/global/models/pagination_model/pagination_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'paginated_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
@immutable
class PaginatedModel<T> {
  const PaginatedModel({required this.data, required this.pagination});

  final List<T> data;
  final PaginationModel pagination;

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedModelToJson(this, toJsonT);

  @override
  String toString() => jsonEncode(toJson((item) => item as Object));

  static PaginatedModel<T> fromString<T>(
    String source,
    T Function(Object? json) fromJsonT,
  ) {
    final Map<String, dynamic> json = jsonDecode(source);
    return PaginatedModel.fromJson(json, fromJsonT);
  }
}
