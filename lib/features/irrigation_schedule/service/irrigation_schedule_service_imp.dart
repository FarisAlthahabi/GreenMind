part of "irrigation_schedule_service.dart";

@Injectable(as: IrrigationScheduleService)
class IrrigationScheduleServiceImp implements IrrigationScheduleService {
  final dio = DioClient();

  @override
  Future<PaginatedModel<IrrigationScheduleModel>> getIrrigationSchedules({
    int page = 1,
    String? search,
    bool? isIrrigated,
    int? plantId,
    String? recommendedDate,
  }) async {
    const storagePath = "irrigation_schedules";
    try {
      final prefs = get<SharedPreferences>();
      bool hasNet = await get<InternetConnectionCubit>().checkInternet();
      final getCached = prefs.getString(storagePath);
      fromJson(json) =>
          IrrigationScheduleModel.fromJson(json as Map<String, dynamic>);
      if (!hasNet && getCached != null && page == 1) {
        return PaginatedModel.fromString(getCached, fromJson);
      }
      final queries = {
        'page': page,
        'is_irrigated': ?isIrrigated,
        'search': ?search,
        'plant_id': ?plantId,
        'recommended_date': ?recommendedDate,
      };
      final response = await dio.get("schedule", queries: queries);
      final data = response.data as Map<String, dynamic>;
      final schedules = PaginatedModel.fromJson(data, fromJson);

      if (page == 1) {
        prefs.setString(storagePath, schedules.toString());
      }

      return schedules;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of getIrrigationSchedules is : $stackTrace");
      }
      rethrow;
    }
  }

  @override
  Future<CompleteIrrigationModel> markCompleted(int id) async {
    try {
      final response = await dio.post("schedule/$id/irrigate");
      final data = response.data["data"] as Map<String, dynamic>;
      return CompleteIrrigationModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of markCompleted is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<IrrigationScheduleModel> rescheduleIrrigation(
    int id,
    String date,
  ) async {
    try {
      final paylod = {"recommended_date": date};
      final response = await dio.put("schedule/$id/reschedule", data: paylod);
      final data = response.data["data"] as Map<String, dynamic>;
      return IrrigationScheduleModel.fromJson(data);
    } catch (e, stackTrace) {
      if (kDebugMode) print("stackTrace of reschedule is : $stackTrace");
      rethrow;
    }
  }

  @override
  Future<void> undoLastIrrigation(int plantId) async {
    try {
      await dio.post("schedule/$plantId/undo");
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of undoLastIrrigation is : $stackTrace");
      }
      rethrow;
    }
  }
}
