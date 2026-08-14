import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/features/plants/model/add_plant_model/add_plant_model.dart';
import 'package:green_mind/features/plants/model/mark_harvested_model/mark_harvested_model.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/service/plants_service.dart';
import 'package:green_mind/features/plants/view/plants_view.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/plants_state.dart';
part 'states/update_plant_state.dart';
part 'states/update_plant_disease_state.dart';
part 'states/mark_harvested_state.dart';
// part 'states/undo_harvest_state.dart';
part 'states/general_plants_state.dart';

@injectable
class PlantsCubit extends Cubit<GeneralPlantsState> {
  PlantsCubit({required this.plantService}) : super(GeneralPlantsInitial());
  final PlantsService plantService;

  List<PlantModel> plants = [];
  String searchQuery = "";
  CropModel? cropFilter;
  HealthStatusEnum? selectedHealthStatus;
  AddPlantModel model = AddPlantModel();
  MarkHarvestedModel markHarvested = MarkHarvestedModel();
  // int? diseaseId;

  // Pagination properties
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  Timer? _debounceTimer;

  void setModel(PlantModel? plant) {
    setCrop(plant?.crop);
    setName(plant?.name);
    setPlantingDate(plant?.plantingDate);
    setHarvestDate(plant?.harvestDate);
    setIrrigarionDays(plant?.baseIrrigationDays);
    setQuantity(plant?.quantity);
    // setHealthStatus(plant?.healthStatus);
    setDiseaseId(plant?.disease);
    setNotes(plant?.notes);
  }

  void clearModel() => model = AddPlantModel();

  void setCrop(CropModel? crop) {
    model = model.copyWith(cropId: () => crop?.id);
  }

  void setName(String? name) {
    model = model.copyWith(name: () => name);
  }

  void setPlantingDate(String? plantingDate) {
    model = model.copyWith(plantingDate: () => plantingDate);
  }

  void setHarvestDate(String? harvestDate) {
    model = model.copyWith(harvestDate: () => harvestDate);
  }

  void setIrrigarionDays(int? days) {
    model = model.copyWith(baseIrrigationDays: () => days);
  }

  // void setHealthStatus(String? healthStatus) {
  //   model = model.copyWith(healthStatus: () => healthStatus);
  // }

  void setQuantity(int? quantity) {
    model = model.copyWith(quantity: () => quantity);
  }

  void setNotes(String? notes) {
    model = model.copyWith(notes: () => notes);
  }

  void setDiseaseId(DiseaseModel? disease) {
    model = model.copyWith(diseaseId: () => disease?.id);
  }

  void setHarvestQuantity(int? quantity) {
    markHarvested = markHarvested.copyWith(harvestQuantity: () => quantity);
  }

  void setStorageLocation(String? location) {
    markHarvested = markHarvested.copyWith(storageLocation: () => location);
  }

  // void setDiseaseId(DiseaseModel? disease) {
  //   diseaseId = disease?.id;
  // }

  // void setSearchQuery(String value) {
  //   searchQuery = value;

  //   // currentPage = 1;
  //   // hasReachedMax = false;
  //   // plants.clear();

  //   search();
  // }

  void setCropFilter(CropModel? crop) {
    cropFilter = crop;
    getPlants(reset: true);
  }

  void setHealthStatusFilter(HealthStatusEnum? status) {
    if (status != null) {
      selectedHealthStatus = status;
      getPlants(reset: true);
    }
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getPlants(reset: true);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  // Future<void> getPlants() async {
  //   emit(PlantsLoading());

  //   if (isClosed) return;
  //   try {
  //     final plants = await plantService.getPlants();
  //     this.plants = plants.data;
  //     search();
  //   } catch (e) {
  //     if (isClosed) return;
  //     emit(PlantsFail(e.toString()));
  //   }
  // }

  Future<void> getPlants({bool reset = false, int perPage = 10}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      plants.clear();
      emit(PlantsLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;

      final paginatedPlants = await plantService.getPlants(
        page: currentPage,
        perPage: perPage,
        search: searchQuery,
        cropId: cropFilter?.id,
        isHealthy: selectedHealthStatus?.value,
      );

      lastPage = paginatedPlants.pagination.lastPage;
      currentPage = paginatedPlants.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        plants = paginatedPlants.data;
      } else {
        plants = [...plants, ...paginatedPlants.data];
      }

      isLoadingMore = false;
      // search();
      emitPlants();
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(PlantsFail(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasReachedMax && !isLoadingMore) {
      currentPage++;
      await getPlants();
    }
  }

  Future<void> updatePlant({int? id}) async {
    final isAdd = id == null;
    model = model.copyWith(isAdd: isAdd);
    emit(UpdatePlantLoading());
    if (isClosed) return;
    try {
      final plant = await plantService.updatePlant(model, id: id);
      emit(UpdatePlantSuccess("action_done".tr(), plant));
      if (isAdd) {
        addLocalPlant(plant);
      } else {
        updateLocalPlant(plant);
      }
    } catch (e) {
      if (isClosed) return;
      emit(UpdatePlantFail(e.toString()));
    }
  }

  // Future<void> updateDiseaseStatus(int id) async {
  //   emit(UpdatePlantDiseaseLoading());
  //   if (isClosed) return;
  //   try {
  //     final plant = await plantService.updateDiseaseStatus(
  //       id,
  //       diseaseId: diseaseId,
  //     );
  //     emit(UpdatePlantDiseaseSuccess("action_done".tr(), plant));
  //     diseaseId = null;
  //     updateLocalPlant(plant);
  //   } catch (e) {
  //     if (isClosed) return;
  //     emit(UpdatePlantDiseaseFail(e.toString()));
  //   }
  // }

  Future<void> markAsHarvested(int id) async {
    emit(MarkHarvestedLoading());
    if (isClosed) return;
    try {
      final plant = await plantService.markAsHarvested(id, markHarvested);
      emit(MarkHarvestedSuccess("action_done".tr(), plant));
      updateLocalPlant(plant);
    } catch (e) {
      if (isClosed) return;
      emit(MarkHarvestedFail(e.toString()));
    }
  }

  // Future<void> undoHarvest(int id) async {
  //   emit(UndoHarvestLoading());
  //   if (isClosed) return;
  //   try {
  //     final plant = await plantService.undoHarvest(id);
  //     emit(UndoHarvestSuccess("action_done".tr(), plant));
  //     updateLocalPlant(plant);
  //   } catch (e) {
  //     if (isClosed) return;
  //     emit(UndoHarvestFail(e.toString()));
  //   }
  // }

  void addLocalPlant(PlantModel plant) {
    plants = [...plants, plant];
    // search();
    emitPlants();
  }

  void updateLocalPlant(PlantModel plant) {
    plants = plants.map((p) => p.id == plant.id ? plant : p).toList();
    // search();
    emitPlants();
  }

  void deleteLocalPlant(PlantModel plant) {
    plants = plants.where((p) => p.id != plant.id).toList();
    // search();
    emitPlants();
  }

  void emitPlants() {
    if (plants.isEmpty) {
      emit(PlantsEmpty("no_plants".tr()));
    } else {
      emit(
        PlantsSuccess(
          plants,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
        ),
      );
    }
  }

  // void search() {
  //   final filtered = plants
  //       .where(
  //         (plant) =>
  //             plant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //             (plant.crop?.nameEn.toLowerCase().contains(
  //                   searchQuery.toLowerCase(),
  //                 ) ??
  //                 false) ||
  //             (plant.crop?.nameAr.toLowerCase().contains(
  //                   searchQuery.toLowerCase(),
  //                 ) ??
  //                 false),
  //       )
  //       .toList();
  //   if (filtered.isEmpty) {
  //     emit(PlantsEmpty("no_plants".tr()));
  //   } else {
  //     emit(
  //       PlantsSuccess(
  //         filtered,
  //         hasReachedMax: hasReachedMax,
  //         currentPage: currentPage,
  //       ),
  //     );
  //   }
  // }
}
