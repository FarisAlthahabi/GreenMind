part of 'diagnosing_diseases_service.dart';

@Injectable(as: DiagnosingDiseasesService)
class DiagnosingDiseasesServiceImp implements DiagnosingDiseasesService {
  final dio = DioClient();

  @override
  Future<void> diagnoiseDesease(XFile image) async {
    try {
      final Map<String, dynamic> data = {};
      data['image'] = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      );
      await dio.post("predict", data: FormData.fromMap(data));
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of predict : $stackTrace");
      rethrow;
    }
  }
}
