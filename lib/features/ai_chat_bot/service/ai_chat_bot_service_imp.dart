part of'ai_chat_bot_service.dart';

@Injectable(as: AiChatBotService)
class AiChatBotServiceImp implements AiChatBotService{
  final dio = DioClient();
}