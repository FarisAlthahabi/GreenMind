import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_response_model/diagnose_response_model.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/models/paginated_model/paginated_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'diagnosing_diseases_service_imp.dart';

abstract class DiagnosingDiseasesService {
  Future<DiagnoseResponseModel> diagnoiseDesease(XFile image, {int? plantId});
  Future<PaginatedModel<DiagnoseModel>> getDiagnoses({
    int page = 1,
    String? search,
    int? plantId,
    int? userId,
    bool? isHealthy,
  });
}
