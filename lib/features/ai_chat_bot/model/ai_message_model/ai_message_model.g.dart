// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiMessageModel _$AiMessageModelFromJson(Map<String, dynamic> json) =>
    AiMessageModel(
      sessionId: json['session_id'] as String,
      reply: json['reply'] as String,
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AiMessageModelToJson(AiMessageModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'reply': instance.reply,
      'sources': instance.sources,
    };
