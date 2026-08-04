part of "plants_service.dart";

@Injectable(as: PlantsService)
class PlantsServiceImp implements PlantsService {
  final dio = DioClient();

  @override
  Future<List<PlantModel>> getPlants() async {
    const storagePath = "plants";
    try {
      final prefs = get<SharedPreferences>();
      bool con = await get<InternetConnectionCubit>().checkInternetConnection();
      final getCached = prefs.getStringList(storagePath);
      if (!con && getCached != null) {
        return getCached.map((e) => PlantModel.fromString(e)).toList();
      }

      final response = await dio.get("plants");
      final data = response.data["data"] as List;
      final plants = data
          .map((plant) => PlantModel.fromJson(plant as Map<String, dynamic>))
          .toList();
      final setCache = plants.map((plant) => plant.toString()).toList();
      prefs.setStringList(storagePath, setCache);

      return plants;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getPlants is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<PlantModel> getPlant(int id) async {
    try {
      final response = await dio.get("plants/$id");
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getPlant $id is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<PlantModel> updatePlant(AddPlantModel plant, {int? id}) async {
    try {
      final path = id == null ? "plants" : "plants/$id";
      final response = await dio.postOrPut(
        path,
        isAdd: id == null,
        data: plant.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of updatePlant ${id ?? ""} is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<PlantModel> markAsHarvested(int id) async {
    try {
      final response = await dio.post("plants/$id/harvest");
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of markAsHarvested $id is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<PlantModel> undoHarvest(int id) async {
    try {
      final response = await dio.post("plants/$id/undo-harvest");
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of undoHarvest $id is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<PlantModel> updateDiseaseStatus(int id, {int? diseaseId}) async {
    try {
      final paylod = {"disease_id": diseaseId};
      final response = await dio.put("plants/$id/disease", data: paylod);
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of updateDiseaseStatus $id is : $stackTrace");
      }
      rethrow;
    }
  }
}
