import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:injectable/injectable.dart';

part 'ai_chat_bot_service_imp.dart';

abstract class AiChatBotService {
  Stream<String> sendMessage(String msg, {String? ctx, String? sessionId});
}
