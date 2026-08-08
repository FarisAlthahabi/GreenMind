import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_response_model/diagnose_response_model.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'diagnosing_diseases_service_imp.dart';

abstract class DiagnosingDiseasesService {
  Future<DiagnoseResponseModel> diagnoiseDesease(XFile image);
}
