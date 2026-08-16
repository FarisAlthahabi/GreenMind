import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/ai_chat_bot/service/ai_chat_bot_service.dart';
import 'package:injectable/injectable.dart';

part 'states/ai_chat_bot_state.dart';
part 'states/general_ai_chat_bot_state.dart';

@injectable
class AiChatBotCubit extends Cubit<GeneralAiChatBotState> {
  AiChatBotCubit({required this.aiChatBotService})
    : super(GeneralAiChatBotInitial());

  final AiChatBotService aiChatBotService;

  final List<ChatMessage> messages = [];
  int currentTries = 5;
  String? currentSessionId;
  StreamSubscription<String>? _streamSubscription;
  String currentAiMessage = '';

  void addMessage(String message, {bool isUser = true}) {
    messages.add(ChatMessage(message: message, isUser: isUser));
    emit(ChatMessagesSuccess(messages));
  }

  // void clearMessages() {
  //   messages.clear();
  //   currentTries = 5;
  //   currentAiMessage = '';
  //   _cancelStream();
  //   emit(CurrentTriesState(currentTries));
  //   emit(ChatMessagesEmpty("-"));
  // }

  void getMessages() {
    emit(CurrentTriesState(currentTries));
    if (messages.isEmpty) {
      emit(ChatMessagesEmpty("-"));
    } else {
      emit(ChatMessagesSuccess(messages));
    }
  }

  Future<void> getAiResponse(String message) async {
    addMessage(message);
    emit(ChatMessagesLoading());
    try {
      if (isClosed) return;
      final aiMessage = await aiChatBotService.sendMessage(
        message,
        ctx: "",
        sessionId: currentSessionId,
      );
      currentSessionId = aiMessage.sessionId;
      addMessage(aiMessage.reply, isUser: false);
      emit(CurrentTriesState(--currentTries));
    } catch (e) {
      if (isClosed) return;
      emit(ChatMessagesFail(e.toString()));
    }
  }

  Future<void> getAiResponseAsStream(String message) async {
    addMessage(message, isUser: true);
    emit(ChatMessagesLoading());
    _cancelStream();
    currentAiMessage = '';
    try {
      // aiChatBotService.sendMessageAsStream(message);
      _streamSubscription = aiChatBotService
          .sendMessageAsStream(message, ctx: "", sessionId: currentSessionId)
          .listen(
            handleChunk,
            onError: handleOnGetAiResponseError,
            onDone: handleOnGetAiResponseDone,
            cancelOnError: true,
          );
    } catch (e) {
      if (!isClosed) {
        emit(ChatMessagesFail(e.toString()));
      }
    }
  }

  void handleChunk(String chunk) {
    if (chunk.startsWith('SESSION_ID:')) {
      currentSessionId = chunk.replaceFirst('SESSION_ID:', '');
      if (kDebugMode) print('Session ID: $currentSessionId');
    } else if (chunk == '[DONE]') {
      emit(CurrentTriesState(--currentTries));
      emit(ChatMessagesSuccess(messages));
    } else {
      currentAiMessage += "$chunk ";
      if (messages.isNotEmpty && !messages.last.isUser) {
        messages.last = ChatMessage(message: currentAiMessage, isUser: false);
      } else {
        messages.add(ChatMessage(message: currentAiMessage, isUser: false));
      }
      emit(ChatMessagesSuccess(messages));
    }
  }

  void handleOnGetAiResponseError(dynamic error) {
    emit(ChatMessagesFail(error.toString()));
  }

  void handleOnGetAiResponseDone() {
    if (!isClosed) emit(CurrentTriesState(--currentTries));
  }

  void _cancelStream() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  Future<void> close() {
    _cancelStream();
    return super.close();
  }
}

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});
}
