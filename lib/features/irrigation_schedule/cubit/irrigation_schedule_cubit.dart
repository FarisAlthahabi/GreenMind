import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/irrigation_schedule/model/complete_irrigation_model/complete_irrigation_model.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/features/irrigation_schedule/service/irrigation_schedule_service.dart';
import 'package:green_mind/features/irrigation_schedule/view/irrigation_schedule_view.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/extensions/date_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/irrigation_schedule_state.dart';
part 'states/general_irrigation_schedule_state.dart';
part 'states/reschedule_irrigation_state.dart';
part 'states/mark_completed_state.dart';
part 'states/undo_irrigation_state.dart';

@injectable
class IrrigationScheduleCubit extends Cubit<GeneralIrrigationScheduleState> {
  IrrigationScheduleCubit({required this.service})
    : super(GeneralIrrigationScheduleInitial());
  final IrrigationScheduleService service;

  List<IrrigationScheduleModel> schedules = [];
  String searchQuery = "";
  Timer? _debounceTimer;
  IrrigationScheduleStatus selectedStatus = IrrigationScheduleStatus.all;
  PlantModel? plantFilter;
  DateTime? recommendedDateFilter;

  // Pagination properties
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  DateTime? newScheduleDate;

  // void setSearchQuery(String value) {
  //   searchQuery = value;
  //   search();
  // }

  void setSearchQuery(String value) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getIrrigationSchedules(reset: true);
    });
  }

  void setStatus(IrrigationScheduleStatus? status) {
    if (status != null) {
      selectedStatus = status;
      getIrrigationSchedules(reset: true);
    }
  }

  void setPlantFilter(PlantModel? plant) {
    plantFilter = plant;
    getIrrigationSchedules(reset: true);
  }

  void setRecommendedDateFilter(DateTime? recommendedDate) {
    recommendedDateFilter = recommendedDate;
    getIrrigationSchedules(reset: true);
  }

  void clearFilters() {
    selectedStatus = .all;
    plantFilter = null;
    recommendedDateFilter = null;
    getIrrigationSchedules(reset: true);
  }

  void setNewScheduleDate(DateTime? date) {
    newScheduleDate = date;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> getIrrigationSchedules({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      schedules.clear();
      emit(IrrigationScheduleLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;

      final paginatedSchedules = await service.getIrrigationSchedules(
        page: currentPage,
        search: searchQuery,
        plantId: plantFilter?.id,
        recommendedDate: recommendedDateFilter?.formatYYYYMMDD,
        isIrrigated: selectedStatus.isIrrigated,
      );

      lastPage = paginatedSchedules.pagination.lastPage;
      currentPage = paginatedSchedules.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        schedules = paginatedSchedules.data;
      } else {
        schedules = [...schedules, ...paginatedSchedules.data];
      }

      isLoadingMore = false;
      emitInventories();
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(IrrigationScheduleFail(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasReachedMax && !isLoadingMore) {
      currentPage++;
      await getIrrigationSchedules();
    }
  }

  Future<void> markCompleted(int id) async {
    emit(MarkCompletedLoading());
    if (isClosed) return;
    try {
      final data = await service.markCompleted(id);
      emit(MarkCompletedSuccess("action_done".tr(), data));
      updateLocalSchedule(data.completedSchedule);
      addLocalSchedule(data.nextSchedule);
      emitInventories();
    } catch (e) {
      if (isClosed) return;
      emit(MarkCompletedFail(e.toString()));
    }
  }

  Future<void> undoLastIrrigation(int plantId) async {
    emit(UndoIrrigationLoading());
    if (isClosed) return;
    try {
      await service.undoLastIrrigation(plantId);
      emit(UndoIrrigationSuccess("action_done".tr()));
      getIrrigationSchedules(reset: true);
    } catch (e) {
      if (isClosed) return;
      emit(UndoIrrigationFail(e.toString()));
    }
  }

  Future<void> rescheduleIrrigation(int id) async {
    if (newScheduleDate == null) {
      emit(RescheduleIrrigationFail("date_required".tr()));
      return;
    }
    emit(RescheduleIrrigationLoading());
    if (isClosed) return;
    try {
      final data = await service.rescheduleIrrigation(
        id,
        newScheduleDate!.formatYYYYMMDD,
      );
      emit(RescheduleIrrigationSuccess("action_done".tr(), data));
      updateLocalSchedule(data);
      emitInventories();
    } catch (e) {
      if (isClosed) return;
      emit(RescheduleIrrigationFail(e.toString()));
    }
  }

  void addLocalSchedule(IrrigationScheduleModel schedule) {
    schedules.add(schedule);
  }

  void updateLocalSchedule(IrrigationScheduleModel schedule) {
    int index = schedules.indexWhere((element) => element.id == schedule.id);
    schedules[index] = schedule;
  }

  void emitInventories() {
    if (schedules.isEmpty) {
      emit(IrrigationScheduleEmpty("no_schedules_found".tr()));
    } else {
      emit(
        IrrigationScheduleSuccess(
          schedules,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
        ),
      );
    }
  }

  // void search() {
  //   if (schedules.isEmpty) {
  //     emit(IrrigationScheduleEmpty("no_irrigation_schedules".tr()));
  //   } else if (searchQuery.isEmpty) {
  //     emit(
  //       IrrigationScheduleSuccess(
  //         schedules,
  //         hasReachedMax: hasReachedMax,
  //         currentPage: currentPage,
  //       ),
  //     );
  //   } else {
  //     final filtered = schedules.where((schedule) {
  //       // Search by recommended date or plant name if available
  //       final dateMatch = schedule.recommendedDate.contains(searchQuery);
  //       final plantMatch =
  //           schedule.plant?.name.toLowerCase().contains(
  //             searchQuery.toLowerCase(),
  //           ) ??
  //           false;
  //       return dateMatch || plantMatch;
  //     }).toList();

  //     if (filtered.isEmpty) {
  //       emit(IrrigationScheduleEmpty("no_schedules_found".tr()));
  //     } else {
  //       emit(
  //         IrrigationScheduleSuccess(
  //           filtered,
  //           hasReachedMax: hasReachedMax,
  //           currentPage: currentPage,
  //         ),
  //       );
  //     }
  //   }
  // }
}
