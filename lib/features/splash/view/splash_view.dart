import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/gen/assets.gen.dart';
import 'package:green_mind/global/mixins/post_frame_mixin.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/utils/constants.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin, PostFrameMixin {
  @override
  Future<void> onPostFrame() async {
    await Future.delayed(AppConstants.duration3s);
    if (mounted) {
      context.router.replace(const AuthManagerRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Assets.images.greenMindPng.image(fit: BoxFit.cover)),
    );
  }
}
