import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/ai_chat_bot/model/ai_message_model/ai_message_model.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:injectable/injectable.dart';

part 'ai_chat_bot_service_imp.dart';

abstract class AiChatBotService {
  Stream<String> sendMessageAsStream(
    String msg, {
    String? ctx,
    String? sessionId,
  });
  Future<AiMessageModel> sendMessage(
    String msg, {
    String? ctx,
    String? sessionId,
  });
}
