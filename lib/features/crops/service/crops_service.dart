import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/crops/model/add_crop_model/add_crop_model.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'crops_service_imp.dart';

abstract class CropsService {
  Future<List<CropModel>> getCrops();
  Future<CropModel> getCrop(int id);
  Future<CropModel> updateCrop(AddCropModel crop, {int? id});
}
