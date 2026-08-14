part of 'diagnosing_diseases_service.dart';

@Injectable(as: DiagnosingDiseasesService)
class DiagnosingDiseasesServiceImp implements DiagnosingDiseasesService {
  final dio = DioClient();

  @override
  Future<DiagnoseResponseModel> diagnoiseDesease(
    XFile image, {
    int? plantId,
  }) async {
    try {
      MultipartFile multipartFile;

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        final mimeType = _getMimeType(image.name);
        multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: image.name,
          contentType: .parse(mimeType),
        );
      } else {
        multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }
      final paylod = {'image': multipartFile, "plant_id": ?plantId};
      final formData = FormData.fromMap(paylod);
      final response = await dio.post("predict", data: formData);

      final data = response.data["data"] as Map<String, dynamic>;
      return DiagnoseResponseModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of predict : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<PaginatedModel<DiagnoseModel>> getDiagnoses({
    int page = 1,
    String? search,
    int? plantId,
    int? userId,
    bool? isHealthy,
  }) async {
    const storagePath = "diagnoses";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);
      fromJson(json) => DiagnoseModel.fromJson(json as Map<String, dynamic>);
      if (!hasNet && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      }

      final queries = {
        'page': page,
        "search": ?search,
        "plant_id": ?plantId,
        "user_id": ?userId,
        "is_healthy": ?isHealthy,
      };
      final response = await dio.get("diagnoses", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final plants = PaginatedModel.fromJson(data, fromJson);
      if (page == 1) {
        prefs.setString(storagePath, plants.toString());
      }

      return plants;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getDiagnoses is : $stackTrace");
      rethrow;
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
