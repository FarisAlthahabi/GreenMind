import 'package:bloc/bloc.dart';
import 'package:green_mind/features/ai_chat_bot/service/ai_chat_bot_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/ai_chat_bot_state.dart';
part 'states/general_ai_chat_bot_state.dart';

@injectable
class AiChatBotCubit extends Cubit<GeneralAiChatBotState> {
  AiChatBotCubit({required this.aiChatBotService})
    : super(GeneralAiChatBotInitial());
  final AiChatBotService aiChatBotService;

  final List<String> messages = [];
  int currentTries = 5;

  void addMessage(String message) {
    messages.add(message);
    emit(ChatMessagesSuccess(messages));
  }

  void clearMessages() {
    messages.clear();
    currentTries = 5;
    emit(CurrentTriesState(currentTries));
    emit(ChatMessagesEmpty("-"));
  }

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
      // final aiMessage = await aiChatBotService.getAiResponse(message);
      await Future.delayed(Duration(seconds: 2));
      final aiMessage = "Ai Responses Successfully";
      addMessage(aiMessage);
      emit(CurrentTriesState(--currentTries));
    } catch (e) {
      if (isClosed) return;
      emit(ChatMessagesFail(e.toString()));
    }
  }
}
