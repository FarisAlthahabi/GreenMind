import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/global/di/di.dart';
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
    return BlocProvider(
      create: (context) => get<AiChatBotCubit>(),
      child: const AiChatBotPage(),
    );
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
      // appBar: MainAppBar(),
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
          border: Border.all(color: context.cs.outline, width: 0.5),
        ),
        child: Column(
          children: [
            _buildRemainingMessages(),
            Divider(height: 0, color: context.cs.outline, thickness: 0.5),
            Expanded(child: _buildChatView()),
            Divider(color: context.cs.outline, thickness: 0.5),
            Padding(padding: AppConstants.padding16, child: TextSenderWidget()),
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
              child: Icon(Icons.drive_eta, color: Colors.white),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    "agricultural_expert".tr(),
                    style: context.tt.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
              child: Icon(Icons.refresh, size: 30),
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
          return Center(
            child: SingleChildScrollView(
              padding: AppConstants.padding16,
              physics: const BouncingScrollPhysics(),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drive_eta, size: 50),
                  Text(
                    "welcome_with_ai_expert".tr(),
                    style: context.tt.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ask_question_about_plants_illnesses".tr(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ChatMessagesSuccess) {
          final messages = state.messages;
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
                  final icon = isAi ? Icons.drive_eta : Icons.person;
                  final iconColor = isAi
                      ? context.cs.primary
                      : context.cs.tertiary;
                  final textColor = isAi
                      ? context.cs.onSurface
                      //TODO check this to come from theme
                      : Colors.white;
                  final textBgColor = isAi
                      ? context.cs.surfaceContainer
                      : context.cs.primary;
                  final borderRadius = isAi
                      ? BorderRadiusDirectional.only(
                          topEnd: Radius.circular(5),
                          bottomEnd: Radius.circular(15),
                          bottomStart: Radius.circular(15),
                          topStart: Radius.circular(15),
                        )
                      : BorderRadiusDirectional.only(
                          topEnd: Radius.circular(15),
                          bottomEnd: Radius.circular(15),
                          bottomStart: Radius.circular(15),
                          topStart: Radius.circular(5),
                        );
                  // TODO fix directionity for english and arabic
                  return Row(
                    mainAxisAlignment: isAi ? .start : .end,
                    children: [
                      Column(
                        spacing: 5,
                        crossAxisAlignment: isAi ? .start : .end,
                        children: [
                          Row(
                            spacing: 10,
                            mainAxisSize: .min,
                            textDirection: isAi ? .rtl : .ltr,
                            children: [
                              CircleAvatar(
                                backgroundColor: iconColor,
                                // TODO check this color to come from theme
                                child: Icon(icon, color: Colors.white),
                              ),
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
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            Utils.formatTimeForMessage(DateTime.now()),
                            // style: context.tt.bodySmall?.copyWith(
                            //   color: context.cs.primary,
                            // ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class TextSenderWidget extends StatefulWidget {
  const TextSenderWidget({super.key});

  @override
  State<TextSenderWidget> createState() => _TextSenderWidgetState();
}

class _TextSenderWidgetState extends State<TextSenderWidget> {
  late final AiChatBotCubit aiChatBotCubit = context.read();
  final textSenderController = TextEditingController();
  // TODO fix this color
  late Color iconColor = context.cs.outline;

  @override
  void initState() {
    super.initState();
    textSenderController.addListener(() {
      setState(() {
        iconColor = textSenderController.text.isEmpty
            ? context.cs.outline
            : context.cs.primary;
      });
    });
  }

  void addMessage(String message) {
    textSenderController.clear();
    aiChatBotCubit.getAiResponse(message);
  }

  @override
  void dispose() {
    textSenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatBotCubit, GeneralAiChatBotState>(
      builder: (context, state) {
        // TODO check this color to come from theme
        Widget icon = Icon(Icons.send, color: Colors.white);
        String hintText = "write_question_here".tr();
        bool readOnly = false;
        var onTap = textSenderController.text.isEmpty
            ? null
            : () => addMessage(textSenderController.text);
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
                controller: textSenderController,
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
