part of 'ai_chat_bot_service.dart';

@Injectable(as: AiChatBotService)
class AiChatBotServiceImp implements AiChatBotService {
  final dioClient = DioClient();

  @override
  Stream<String> sendMessageAsStream(
    String msg, {
    String? ctx,
    String? sessionId,
  }) async* {
    try {
      final data = {'message': msg, 'context': ctx, 'session_id': sessionId};
      final response = await dioClient.postStreaming(
        'chat',
        data: data,
        duration: AppConstants.duration2m,
      );

      final headers = response.headers;
      String? newSessionId = headers.value('x-session-id');

      if (newSessionId != null) {
        yield 'SESSION_ID:$newSessionId';
      }

      if (response.data is ResponseBody) {
        final stream = (response.data as ResponseBody).stream;

        await for (var chunk in stream) {
          final String chunkString = utf8.decode(chunk as List<int>);
          final lines = chunkString.split('\n');

          for (var line in lines) {
            final trimmedLine = line.trim();
            if (trimmedLine.isEmpty) continue;

            if (trimmedLine == '[DONE]') {
              yield '[DONE]';
              break;
            }

            if (trimmedLine.startsWith('data: ')) {
              final dataPayload = trimmedLine.replaceFirst('data: ', '');
              try {
                final jsonData = jsonDecode(dataPayload);
                String tokenText =
                    jsonData['token'] ??
                    jsonData['chunk'] ??
                    jsonData['reply'] ??
                    '';
                if (tokenText.isNotEmpty) {
                  yield tokenText;
                }
              } catch (e) {
                yield dataPayload;
              }
            } else {
              yield trimmedLine;
            }
          }
        }
      } else {
        yield response.data.toString();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("StackTrace of sendMessage: $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<AiMessageModel> sendMessage(
    String msg, {
    String? ctx,
    String? sessionId,
  }) async {
    try {
      final paylod = {'message': msg, 'context': ctx, 'session_id': sessionId};
      final response = await dioClient.post(
        'chat',
        data: paylod,
        duration: AppConstants.duration2m,
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return AiMessageModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("StackTrace of sendMessage: $stackTrace");
      }
      rethrow;
    }
  }
}
