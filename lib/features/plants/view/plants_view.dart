import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

abstract class PlantsViewCallBacks {}

@RoutePage()
class PlantsView extends StatelessWidget {
  const PlantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlantsPage();
  }
}

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage>
    implements PlantsViewCallBacks {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
