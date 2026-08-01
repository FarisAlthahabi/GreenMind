part of "irrigation_schedule_service.dart";

@Injectable(as: IrrigationScheduleService)
class IrrigationScheduleServiceImp implements IrrigationScheduleService {
  final dio = DioClient();

  @override
  Future<List<IrrigationScheduleModel>> getIrrigationSchedules() async {
    const storagePath = "irrigation_schedules";
    try {
      final prefs = get<SharedPreferences>();
      bool con = await get<InternetConnectionCubit>().checkInternetConnection();
      final getCached = prefs.getStringList(storagePath);

      if (!con && getCached != null) {
        return getCached
            .map((e) => IrrigationScheduleModel.fromString(e))
            .toList();
      }

      final response = await dio.get("schedule");
      final data = response.data["data"] as List;
      final schedules = data
          .map(
            (schedule) => IrrigationScheduleModel.fromJson(
              schedule as Map<String, dynamic>,
            ),
          )
          .toList();

      final setCache = schedules
          .map((schedule) => schedule.toString())
          .toList();
      prefs.setStringList(storagePath, setCache);

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
      await dio.put("schedule/$plantId/undo");
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace of undoLastIrrigation is : $stackTrace");
      }
      rethrow;
    }
  }
}
