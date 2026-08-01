import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/irrigation_schedule/model/complete_irrigation_model/complete_irrigation_model.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'irrigation_schedule_service_imp.dart';

abstract class IrrigationScheduleService {
  Future<List<IrrigationScheduleModel>> getIrrigationSchedules();
  Future<CompleteIrrigationModel> markCompleted(int id);
  Future<void> undoLastIrrigation(int plantId);
  Future<IrrigationScheduleModel> rescheduleIrrigation(int id, String date);
}
