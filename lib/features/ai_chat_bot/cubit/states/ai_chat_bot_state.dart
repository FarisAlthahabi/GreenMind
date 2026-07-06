part of '../ai_chat_bot_cubit.dart';

// @immutable
// class AiChatBotState extends GeneralAiChatBotState {}

// final class AiChatBotLoading extends AiChatBotState {}

// final class AiChatBotSuccess extends AiChatBotState {
//   final String message;

//   AiChatBotSuccess(this.message);
// }

// final class AiChatBotFail extends AiChatBotState {
//   final String error;

//   AiChatBotFail(this.error);
// }

@immutable
class ChatMessagesState extends GeneralAiChatBotState {}

class ChatMessagesLoading extends ChatMessagesState {}

final class ChatMessagesSuccessOrEmpty extends ChatMessagesState {}

final class ChatMessagesSuccess extends ChatMessagesSuccessOrEmpty {
  final List<String> messages;

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
