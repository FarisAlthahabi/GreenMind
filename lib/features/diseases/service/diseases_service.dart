import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/diseases/model/add_disease_model/add_disease_model.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'diseases_service_imp.dart';

abstract class DiseasesService {
  Future<List<DiseaseModel>> getDiseases();
  Future<DiseaseModel> getDisease(int id);
  Future<DiseaseModel> updateDisease(AddDiseaseModel disease, {int? id});
}