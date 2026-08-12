part of '../ai_chat_bot_cubit.dart';

@immutable
class ChatMessagesState extends GeneralAiChatBotState {}

class ChatMessagesLoading extends ChatMessagesState {}

final class ChatMessagesSuccessOrEmpty extends ChatMessagesState {}

final class ChatMessagesSuccess extends ChatMessagesSuccessOrEmpty {
  final List<ChatMessage> messages;

  ChatMessagesSuccess(this.messages);
}

final class ChatMessagesEmpty extends ChatMessagesSuccessOrEmpty {
  final String message;

  ChatMessagesEmpty(this.message);
}

final class ChatMessagesFail extends ChatMessagesState {
  final String error;

  ChatMessagesFail(this.error);
}
