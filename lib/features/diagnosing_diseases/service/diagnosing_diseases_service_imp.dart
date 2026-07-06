part of 'diagnosing_diseases_service.dart';

@Injectable(as: DiagnosingDiseasesService)
class DiagnosingDiseasesServiceImp implements DiagnosingDiseasesService {
  final dio = DioClient();
}
