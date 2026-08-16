import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/global/mixins/post_frame_mixin.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';

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
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

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
      body: Center(
        child: Column(
          crossAxisAlignment: .center,
          mainAxisAlignment: .center,
          // mainAxisSize: .min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Utils.appLogo(context, width: 200),
                // child: Assets.images.png.greenMindPng.image(width: 200),
              ),
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: AppConstants.paddingH4,
                child: Text(
                  "Welcome to ${AppConstants.appName}",
                  textAlign: .center,
                  style: context.tt.headlineMedium?.copyWith(
                    fontWeight: .bold,
                    color: context.cs.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
