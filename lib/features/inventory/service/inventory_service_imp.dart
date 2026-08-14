// inventory_service_imp.dart
part of 'inventory_service.dart';

@Injectable(as: InventoryService)
class InventoryServiceImp implements InventoryService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<InventoryModel>> getInventories({
    int page = 1,
    String? search,
  }) async {
    const storagePath = "inventories";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);

      InventoryModel fromJson(dynamic json) =>
          InventoryModel.fromJson(json as Map<String, dynamic>);

      if (!hasNet && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      }
      final queries = <String, dynamic>{'page': page, 'search': ?search};
      final response = await dio.get("inventory", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final models = PaginatedModel.fromJson(data, fromJson);
      if (page == 1) {
        prefs.setString(storagePath, models.toString());
      }

      return models;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of getInventories is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<InventoryModel> dispatchInventory(
    int id,
    DispatchInventoryModel model,
  ) async {
    try {
      final response = await dio.post(
        "inventory/$id/dispatch",
        data: model.toJson(),
      );
      final data = response.data["data"] as Map<String, dynamic>;
      return InventoryModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of markAsHarvested $id is : $stackTrace");
      }
      rethrow;
    }
  }
}
