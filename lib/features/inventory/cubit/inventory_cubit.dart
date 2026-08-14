import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/inventory/model/dispatch_inventory_model/dispatch_inventory_model.dart';
import 'package:green_mind/features/inventory/model/inventory_model/inventory_model.dart';
import 'package:green_mind/features/inventory/service/inventory_service.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/inventory_state.dart';
part 'states/dispatch_inventory_state.dart';
part 'states/general_inventory_state.dart';

@injectable
class InventoryCubit extends Cubit<GeneralInventoryState> {
  InventoryCubit({required this.inventoryService})
    : super(GeneralInventoryInitial());
  final InventoryService inventoryService;

  DispatchInventoryModel model = DispatchInventoryModel();

  List<InventoryModel> inventories = [];
  String searchQuery = "";
  Timer? _debounceTimer;

  // Pagination properties
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  void setQuantityUsed(int? quantity) {
    model = model.copyWith(quantityUsed: () => quantity);
  }

  void setReason(String? reason) {
    model = model.copyWith(reason: () => reason);
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getInventories(reset: true);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> getInventories({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      inventories.clear();
      emit(InventoriesLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;

      final paginatedData = await inventoryService.getInventories(
        page: currentPage,
        search: searchQuery,
      );

      lastPage = paginatedData.pagination.lastPage;
      currentPage = paginatedData.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        inventories = paginatedData.data;
      } else {
        inventories = [...inventories, ...paginatedData.data];
      }

      isLoadingMore = false;
      emitInventories();
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(InventoriesFail(e.toString()));
    }
  }

  void emitInventories() {
    if (inventories.isEmpty) {
      emit(InventoriesEmpty("no_inventories".tr()));
    } else {
      emit(
        InventoriesSuccess(
          inventories,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
        ),
      );
    }
  }

  Future<void> dispatchInventory(int id) async {
    emit(DispatchInventoryLoading());
    if (isClosed) return;
    try {
      final plant = await inventoryService.dispatchInventory(id, model);
      emit(DispatchInventorySuccess("action_done".tr(), plant));
      // TODO check this
      // updateLocalPlant(plant);
    } catch (e) {
      if (isClosed) return;
      emit(DispatchInventoryFail(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasReachedMax && !isLoadingMore) {
      currentPage++;
      await getInventories();
    }
  }
}
