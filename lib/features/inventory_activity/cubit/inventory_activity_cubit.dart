// inventory_activity_cubit.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/inventory_activity/model/inventory_activity_model/inventory_activity_model.dart';
import 'package:green_mind/features/inventory_activity/service/inventory_activity_service.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/inventory_activity_state.dart';
part 'states/general_inventory_activity_state.dart';

@injectable
class InventoryActivityCubit extends Cubit<GeneralInventoryActivityState> {
  InventoryActivityCubit({required this.service})
    : super(GeneralInventoryActivityInitial());
  final InventoryActivityService service;

  List<InventoryActivityModel> activities = [];
  String searchQuery = "";
  UserModel? userFilter;
  Timer? _debounceTimer;

  // Pagination properties
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  void setSearchQuery(String value) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getActivities(reset: true);
    });
  }

  void setUserIdFilter(UserModel? user) {
    userFilter = user;
    getActivities(reset: true);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> getActivities({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      activities.clear();
      emit(ActivitiesLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;

      final paginatedData = await service.getInventoryActivities(
        page: currentPage,
        search: searchQuery,
        userId: userFilter?.id,
      );

      lastPage = paginatedData.pagination.lastPage;
      currentPage = paginatedData.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        activities = paginatedData.data;
      } else {
        activities = [...activities, ...paginatedData.data];
      }

      isLoadingMore = false;
      emitActivities();
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(ActivitiesFail(e.toString()));
    }
  }

  void emitActivities() {
    if (activities.isEmpty) {
      emit(ActivitiesEmpty("no_activities".tr()));
    } else {
      emit(
        ActivitiesSuccess(
          activities,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (!hasReachedMax && !isLoadingMore) {
      currentPage++;
      await getActivities();
    }
  }
}
