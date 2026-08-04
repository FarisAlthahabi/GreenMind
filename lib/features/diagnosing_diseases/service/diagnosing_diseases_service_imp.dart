part of 'diagnosing_diseases_service.dart';

@Injectable(as: DiagnosingDiseasesService)
class DiagnosingDiseasesServiceImp implements DiagnosingDiseasesService {
  final dio = DioClient();

  @override
  Future<DiagnoseModel> diagnoiseDesease(XFile image) async {
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
        // Mobile/Desktop - use file path
        multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
      }
      final formData = FormData.fromMap({'image': multipartFile});
      final response = await dio.post("predict", data: formData);

      // final Map<String, dynamic> paylod = {};
      // paylod['image'] = await MultipartFile.fromFile(
      //   image.path,
      //   filename: image.name,
      // );

      // final response = await dio.post(
      //   "predict",
      //   data: FormData.fromMap(paylod),
      // );
      final data = response.data["data"] as Map<String, dynamic>;
      return DiagnoseModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of predict : $stackTrace");
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
