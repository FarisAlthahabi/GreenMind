part of "stats_service.dart";

@Injectable(as: StatsService)
class StatsServiceImp implements StatsService {
  final dio = DioClient();

  @override
  Future<StatsModel> getStats() async {
    try {
      final response = await dio.get("dashboard");
      final data = response.data["data"] as Map<String, dynamic>;
      return StatsModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of getStats is : $stackTrace");
      rethrow;
    }
  }
}
