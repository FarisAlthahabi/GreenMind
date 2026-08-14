part of "plants_service.dart";

@Injectable(as: PlantsService)
class PlantsServiceImp implements PlantsService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<PlantModel>> getPlants({
    int page = 1,
    required int perPage,
    String? search,
    int? cropId,
    bool? isHealthy,
  }) async {
    const storagePath = "plants";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);
      fromJson(json) => PlantModel.fromJson(json as Map<String, dynamic>);
      if (!hasNet && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      }

      final queries = {
        'page': page,
        'per_page': perPage,
        "search": ?search,
        "crop_id": ?cropId,
        "is_healthy": ?isHealthy,
      };
      final response = await dio.get("plants", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final plants = PaginatedModel.fromJson(data, fromJson);
      if (page == 1) {
        prefs.setString(storagePath, plants.toString());
      }

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
  Future<PlantModel> markAsHarvested(int id, MarkHarvestedModel model) async {
    try {
      final response = await dio.post(
        "plants/$id/harvest",
        data: model.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return PlantModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of markAsHarvested $id is : $stackTrace");
      }
      rethrow;
    }
  }

  // @override
  // Future<PlantModel> undoHarvest(int id) async {
  //   try {
  //     final response = await dio.post("plants/$id/undo-harvest");
  //     final data = response.data["data"] as Map<String, dynamic>;
  //     return PlantModel.fromJson(data);
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("stackTrace of undoHarvest $id is : $stackTrace");
  //     }
  //     rethrow;
  //   }
  // }

  // @override
  // Future<PlantModel> updateDiseaseStatus(int id, {int? diseaseId}) async {
  //   try {
  //     final paylod = {"disease_id": diseaseId};
  //     final response = await dio.put("plants/$id/disease", data: paylod);
  //     final data = response.data["data"] as Map<String, dynamic>;
  //     return PlantModel.fromJson(data);
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("stackTrace of updateDiseaseStatus $id is : $stackTrace");
  //     }
  //     rethrow;
  //   }
  // }
}
