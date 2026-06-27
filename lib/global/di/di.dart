import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/di/di.config.dart';

final get = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async => get.init();
