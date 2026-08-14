part of 'inventory_activity_service.dart';

@Injectable(as: InventoryActivityService)
class InventoryActivityServiceImp implements InventoryActivityService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<InventoryActivityModel>> getInventoryActivities({
    int page = 1,
    String? search,
    int? userId,
  }) async {
    const storagePath = "inventory_activities";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);

      InventoryActivityModel fromJson(dynamic json) =>
          InventoryActivityModel.fromJson(json as Map<String, dynamic>);

      if (!hasNet && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      }

      final queries = {'page': page, 'search': ?search, 'user_id': ?userId};
      final response = await dio.get("inventory-usages", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final models = PaginatedModel.fromJson(data, fromJson);

      if (page == 1) {
        prefs.setString(storagePath, models.toString());
      }
      return models;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of getInventoryActivities is : $stackTrace");
      }
      rethrow;
    }
  }
}
