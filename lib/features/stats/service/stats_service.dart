import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/stats/model/stats_model/stats_model.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';

part 'stats_service_imp.dart';

abstract class StatsService {
  Future<StatsModel> getStats();
}
