import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/app/green_mind_material_app.dart';
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/localization/supported_locales.dart';
import 'package:green_mind/global/theme/cubit/theme_cubit.dart';

class GreenMindApp extends StatelessWidget {
  const GreenMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => get<AuthManagerBloc>()),
        BlocProvider(create: (_) => get<InternetConnectionCubit>()),
        BlocProvider(create: (_) => get<ThemeCubit>()),
      ],
      child: EasyLocalization(
        supportedLocales: SupportedLocales.locales,
        path: SupportedLocales.path,
        fallbackLocale: SupportedLocales.arabic,
        startLocale: SupportedLocales.arabic,
        child: const GreenMindMaterialApp(),
      ),
    );
  }
}
