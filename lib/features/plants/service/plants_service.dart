import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/plants/model/add_plant_model/add_plant_model.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/models/paginated_model/paginated_model.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'plants_service_imp.dart';

abstract class PlantsService {
  Future<PaginatedModel<PlantModel>> getPlants({int page = 1});
  Future<PlantModel> getPlant(int id);
  Future<PlantModel> updatePlant(AddPlantModel plant, {int? id});
  Future<PlantModel> updateDiseaseStatus(int id, {int? diseaseId});
  Future<PlantModel> markAsHarvested(int id);
  Future<PlantModel> undoHarvest(int id);
}
