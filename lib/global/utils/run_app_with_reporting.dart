import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/app/app.dart';
import 'package:green_mind/global/blocs/app_bloc_observer.dart';
import 'package:green_mind/global/di/di.dart';

Future<void> runAppWithReporting() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();
      await EasyLocalization.ensureInitialized();

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      Bloc.observer = AppBlocObserver();
      runApp(const App());
    },
    (error, stackTrace) async {
      debugPrint('runAppWithReporting error: $error');
      debugPrint('runAppWithReporting stackTrace: $stackTrace');
    },
  );
}