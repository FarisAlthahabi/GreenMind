import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ai_message_model.g.dart';

@JsonSerializable()
@immutable
class AiMessageModel extends Equatable {
  const AiMessageModel({
    required this.sessionId,
    required this.reply,
    this.sources = const [],
  });

  @JsonKey(name: "session_id")
  final String sessionId;

  final String reply;
  final List<String> sources;

  factory AiMessageModel.fromJson(Map<String, dynamic> json) =>
      _$AiMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiMessageModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AiMessageModel.fromString(String jsonString) {
    return AiMessageModel.fromJson(json.decode(jsonString));
  }

  AiMessageModel copyWith({
    String? sessionId,
    String? reply,
    List<String>? sources,
  }) {
    return AiMessageModel(
      sessionId: sessionId ?? this.sessionId,
      reply: reply ?? this.reply,
      sources: sources ?? this.sources,
    );
  }

  @override
  List<Object?> get props => [sessionId, reply, sources];

  @override
  bool? get stringify => null;
}
