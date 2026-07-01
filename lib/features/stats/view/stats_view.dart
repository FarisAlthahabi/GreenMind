import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';

@RoutePage()
class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsPage();
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MainAppBar(),
    );
  }
}