part of "crops_service.dart";

@Injectable(as: CropsService)
class CropsServiceImp implements CropsService {
  final dio = DioClient();

  @override
  Future<List<CropModel>> getCrops() async {
    const storagePath = "crops";
    try {
      final prefs = get<SharedPreferences>();
      bool con = await get<InternetConnectionCubit>().checkInternetConnection();
      final getCached = prefs.getStringList(storagePath);
      if (!con && getCached != null) {
        return getCached.map((e) => CropModel.fromString(e)).toList();
      } else if (!con && getCached == null) {
        throw "no_internet".tr();
      }

      final response = await dio.get("crops");
      final data = response.data["data"] as List;
      final crops = data
          .map((crop) => CropModel.fromJson(crop as Map<String, dynamic>))
          .toList();
      final setCache = crops.map((crop) => crop.toString()).toList();
      prefs.setStringList(storagePath, setCache);

      return crops;
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getCrops is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<CropModel> getCrop(int id) async {
    try {
      final response = await dio.get("crops/$id");
      final data = response.data["data"] as Map<String, dynamic>;
      return CropModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getCrop $id is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<CropModel> updateCrop(AddCropModel crop, {int? id}) async {
    try {
      final path = id == null ? "crops" : "crops/$id";
      final response = await dio.postOrPut(
        path,
        isAdd: id == null,
        data: crop.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return CropModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of updateCrop ${id ?? ""} is : $stackTrace");
      }
      rethrow;
    }
  }
}
