import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/global/router/app_router.dart';
import 'package:green_mind/global/theme/cubit/theme_cubit.dart';
import 'package:green_mind/global/theme/themes/theme.dart';
import 'package:green_mind/global/utils/utils.dart';

class GreenMindMaterialApp extends StatefulWidget {
  const GreenMindMaterialApp({super.key});

  @override
  State<GreenMindMaterialApp> createState() => _GreenMindMaterialAppState();
}

class _GreenMindMaterialAppState extends State<GreenMindMaterialApp> {
  final appRouter = AppRouter();

  late ThemeData lightThemeData;
  late ThemeData darkThemeData;

  @override
  void initState() {
    super.initState();
    const baseTextTheme = TextTheme();
    final textTheme = createTextTheme(baseTextTheme, "Cairo", "Cairo");
    final materialTheme = MaterialTheme(textTheme);

    lightThemeData = materialTheme.light();
    darkThemeData = materialTheme.dark();
  }

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
          theme: lightThemeData,
          darkTheme: darkThemeData,
        );
      },
    );
  }
}
