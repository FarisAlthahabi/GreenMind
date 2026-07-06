part of '../ai_chat_bot_cubit.dart';

abstract class GeneralAiChatBotState {}

class GeneralAiChatBotInitial extends GeneralAiChatBotState{}

class CurrentTriesState extends GeneralAiChatBotState{
  final int currentTries;

  CurrentTriesState(this.currentTries);
}