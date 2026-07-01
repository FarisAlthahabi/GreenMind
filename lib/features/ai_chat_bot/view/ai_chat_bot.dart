import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MainAppBar(),
    );
  }
}