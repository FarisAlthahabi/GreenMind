import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/global/router/app_router.dart';
import 'package:green_mind/global/theme/cubit/theme_cubit.dart';
import 'package:green_mind/global/theme/themes/dark_theme.dart';
import 'package:green_mind/global/theme/themes/light_theme.dart';

class AppMaterialApp extends StatefulWidget {
  const AppMaterialApp({super.key});

  @override
  State<AppMaterialApp> createState() => _AppMaterialAppState();
}

class _AppMaterialAppState extends State<AppMaterialApp> {
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        ThemeMode themeMode = ThemeMode.system;
        if (state is ThemeChanged) {
          themeMode = state.themeMode;
        }
        return MaterialApp.router(
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}
