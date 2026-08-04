import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

@RoutePage()
class AiChatBotView extends StatelessWidget {
  const AiChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AiChatBotPage();
  }
}

class AiChatBotPage extends StatefulWidget {
  const AiChatBotPage({super.key});

  @override
  State<AiChatBotPage> createState() => _AiChatBotPageState();
}

class _AiChatBotPageState extends State<AiChatBotPage> {
  late final AiChatBotCubit aiChatBotCubit = context.read();
  final scrollController = ScrollController();
  final senderController = TextEditingController();
  // String initialMessage = '';

  @override
  void initState() {
    super.initState();
    aiChatBotCubit.getMessages();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          children: [_buildHeaderDescription(), _buildChatContent()],
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: AppConstants.borderRadius20,
          border: .all(color: context.cs.outline, width: 0.5),
        ),
        child: Column(
          children: [
            _buildRemainingMessages(),
            Divider(height: 0, color: context.cs.outline, thickness: 0.5),
            Expanded(child: _buildChatView()),
            Divider(color: context.cs.outline, thickness: 0.5),
            Padding(
              padding: AppConstants.padding16,
              child: TextSenderWidget(senderController: senderController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return Container(
      width: double.infinity,
      padding: AppConstants.paddingH16V12,
      decoration: BoxDecoration(
        color: context.cs.errorContainer,
        borderRadius: AppConstants.borderRadius10,
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: context.cs.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'responses_for_consultation'.tr(),
              style: context.tt.bodyLarge?.copyWith(
                color: context.cs.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingMessages() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.cs.primaryContainer,
        borderRadius: AppConstants.borderRadiusT20,
      ),
      child: Padding(
        padding: AppConstants.padding16,
        child: Row(
          spacing: 15,
          children: [
            CircleAvatar(
              backgroundColor: context.cs.primary,
              // TODO check this color to come from theme
              child: const Icon(Icons.agriculture, color: Colors.white),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 5,
                children: [
                  Text(
                    "agricultural_expert".tr(),
                    style: context.tt.bodyLarge?.copyWith(fontWeight: .bold),
                  ),
                  BlocBuilder<AiChatBotCubit, GeneralAiChatBotState>(
                    buildWhen: (previous, current) =>
                        current is CurrentTriesState,
                    builder: (context, state) {
                      int currentTries = 5;
                      String text =
                          "${"available".tr()} - $currentTries ${"remaining_messages".tr()}";
                      if (state is CurrentTriesState) {
                        currentTries = state.currentTries;
                        if (currentTries == 0) {
                          text = "session_ended".tr();
                        } else {
                          text =
                              "${"available".tr()} - $currentTries ${"remaining_messages".tr()}";
                        }
                      }
                      return Text(text);
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: aiChatBotCubit.clearMessages,
              child: Icon(Icons.refresh, size: 30, color: context.cs.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return BlocConsumer<AiChatBotCubit, GeneralAiChatBotState>(
      buildWhen: (previous, current) => current is ChatMessagesSuccessOrEmpty,
      listener: (context, state) {
        if (state is ChatMessagesSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToBottom();
          });
        } else if (state is ChatMessagesFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is ChatMessagesEmpty) {
          return _buildEmptyState();
        }
        if (state is ChatMessagesSuccess) {
          return _buildMessagesList(state.messages);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildEmptyState() {
    const initialTexts = [
      "ما هي أمراض الطماطم الشائعة؟",
      "كيف أعالج اللفحة المتأخرة؟",
      "ما هو جدول الري المناسب للبطاطا؟",
      "ما هي أعراض مرض تبقع الأوراق؟",
    ];
    return Center(
      child: SingleChildScrollView(
        padding: AppConstants.padding16,
        physics: const BouncingScrollPhysics(),
        child: Column(
          spacing: 10,
          mainAxisAlignment: .center,
          children: [
            Icon(
              Icons.agriculture,
              size: 50,
              color: context.cs.onSurfaceVariant,
            ),
            Text(
              "welcome_with_ai_expert".tr(),
              style: context.tt.bodyLarge?.copyWith(fontWeight: .bold),
            ),
            const Text(
              "ask_question_about_plants_illnesses",
              textAlign: .center,
            ).tr(),
            const SizedBox.shrink(),
            AnimationLimiter(
              child: GridView.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                childAspectRatio: 2.2,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(initialTexts.length, (int index) {
                  final text = initialTexts[index];
                  return AnimationConfiguration.staggeredGrid(
                    delay: AppConstants.duration200ms,
                    position: index,
                    duration: AppConstants.duration500ms,
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {
                            senderController.text = text;
                          },
                          child: Container(
                            padding: AppConstants.padding12,
                            decoration: BoxDecoration(
                              color: context.cs.surface,
                              borderRadius: AppConstants.borderRadius20,
                              border: .all(
                                width: 0.2,
                                color: context.cs.onSurface,
                              ),
                            ),
                            child: Center(
                              child: Text(text, textAlign: .center),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(List<String> messages) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: AppConstants.padding16,
      physics: const BouncingScrollPhysics(),
      child: Column(
        spacing: 10,
        children: [
          ...List.generate(messages.length, (index) {
            final message = messages[index];
            final isAi = index.isOdd;
            return _buildMessageBubble(message, isAi);
          }),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isAi) {
    final icon = isAi ? Icons.agriculture : Icons.person;
    final iconColor = isAi ? context.cs.primary : context.cs.tertiary;
    final textColor = isAi ? context.cs.onSurface : Colors.white;
    final textBgColor = isAi ? context.cs.surfaceContainer : context.cs.primary;
    final borderRadius = isAi
        ? AppConstants.borderRadius15TE5
        : AppConstants.borderRadius15TS5;

    return Row(
      mainAxisAlignment: isAi ? .start : .end,
      crossAxisAlignment: .start,
      children: [
        if (!isAi)
          const Spacer()
        else ...[
          CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: isAi ? .start : .end,
            spacing: 5,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: textBgColor,
                  borderRadius: borderRadius,
                ),
                child: Padding(
                  padding: AppConstants.padding12,
                  child: Text(
                    message,
                    style: context.tt.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
              Text(
                Utils.formatTimeForMessage(DateTime.now()),
                style: context.tt.bodySmall?.copyWith(
                  color: context.cs.outline,
                ),
              ),
            ],
          ),
        ),
        if (!isAi) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ] else
          const Spacer(),
      ],
    );
  }
}

class TextSenderWidget extends StatefulWidget {
  const TextSenderWidget({super.key, required this.senderController});
  final TextEditingController senderController;

  @override
  State<TextSenderWidget> createState() => _TextSenderWidgetState();
}

class _TextSenderWidgetState extends State<TextSenderWidget> {
  late final AiChatBotCubit aiChatBotCubit = context.read();
  // TODO fix this color
  late Color iconColor = context.cs.outline;

  @override
  void initState() {
    super.initState();
    widget.senderController.addListener(() {
      setState(() {
        iconColor = widget.senderController.text.isEmpty
            ? context.cs.outline
            : context.cs.primary;
      });
    });
  }

  void addMessage(String message) {
    widget.senderController.clear();
    aiChatBotCubit.getAiResponse(message);
  }

  @override
  void dispose() {
    widget.senderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatBotCubit, GeneralAiChatBotState>(
      builder: (context, state) {
        // TODO check this color to come from theme
        Widget icon = const Icon(Icons.send, color: Colors.white);
        String hintText = "write_question_here".tr();
        bool readOnly = false;
        var onTap = widget.senderController.text.isEmpty
            ? null
            : () => addMessage(widget.senderController.text);
        if (state is ChatMessagesLoading) {
          icon = LoadingIndicator(color: context.cs.onPrimary, size: 25);
          onTap = null;
        }
        if (state is CurrentTriesState) {
          if (state.currentTries == 0) {
            hintText = "${"session_ended".tr()} - ${"start_new_chat".tr()}";
            readOnly = true;
          }
        }
        return Row(
          spacing: 10,
          children: [
            Expanded(
              child: MainTextField(
                controller: widget.senderController,
                hintText: hintText,
                hintColor: context.cs.outline,
                borderRadius: AppConstants.borderRadius30,
                fillColor: context.cs.surfaceContainer,
                borderColor: context.cs.outline,
                borderWidth: 0.3,
                readOnly: readOnly,
              ),
            ),
            InkWell(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(padding: AppConstants.padding16, child: icon),
              ),
            ),
          ],
        );
      },
    );
  }
}
