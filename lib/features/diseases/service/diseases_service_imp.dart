part of "diseases_service.dart";

@Injectable(as: DiseasesService)
class DiseasesServiceImp implements DiseasesService {
  final dio = DioClient();

  @override
  Future<List<DiseaseModel>> getDiseases() async {
    const storagePath = "diseases";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getStringList(storagePath);
      if (!hasNet && getCached != null) {
        return getCached.map((e) => DiseaseModel.fromString(e)).toList();
      } 

      final response = await dio.get("diseases");
      final data = response.data["data"] as List;
      final diseases = data
          .map(
            (disease) => DiseaseModel.fromJson(disease as Map<String, dynamic>),
          )
          .toList();
      final setCache = diseases.map((disease) => disease.toString()).toList();
      prefs.setStringList(storagePath, setCache);

      return diseases;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getDiseases is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<DiseaseModel> getDisease(int id) async {
    try {
      final response = await dio.get("diseases/$id");
      final data = response.data["data"] as Map<String, dynamic>;
      return DiseaseModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getDisease $id is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<DiseaseModel> updateDisease(AddDiseaseModel disease, {int? id}) async {
    try {
      final path = id == null ? "diseases" : "diseases/$id";
      final response = await dio.postOrPut(
        path,
        isAdd: id == null,
        data: disease.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return DiseaseModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of updateDisease ${id ?? ""} is : $stackTrace");
      }
      rethrow;
    }
  }
}
