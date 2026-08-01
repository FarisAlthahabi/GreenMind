import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/features/plants/model/add_plant_model/add_plant_model.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/service/plants_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/plants_state.dart';
part 'states/update_plant_state.dart';
part 'states/general_plants_state.dart';

@injectable
class PlantsCubit extends Cubit<GeneralPlantsState> {
  PlantsCubit({required this.plantService}) : super(GeneralPlantsInitial());
  final PlantsService plantService;

  List<PlantModel> plants = [];
  String searchQuery = "";
  AddPlantModel model = AddPlantModel();

  void setModel(PlantModel? plant) {
    setCrop(plant?.crop);
    setName(plant?.name);
    setPlantingDate(plant?.plantingDate);
    setHarvestDate(plant?.harvestDate);
    setQuantity(plant?.quantity);
    setHealthStatus(plant?.healthStatus);
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

  void setHealthStatus(String? healthStatus) {
    model = model.copyWith(healthStatus: () => healthStatus);
  }

  void setQuantity(int? quantity) {
    model = model.copyWith(quantity: () => quantity);
  }

  void setNotes(String? notes) {
    model = model.copyWith(notes: () => notes);
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    search();
  }

  Future<void> getPlants() async {
    emit(PlantsLoading());
    if (isClosed) return;
    try {
      final plants = await plantService.getPlants();
      this.plants = plants;
      search();
    } catch (e) {
      if (isClosed) return;
      emit(PlantsFail(e.toString()));
    }
  }

  Future<void> updatePlant({int? id}) async {
    emit(UpdatePlantLoading());
    if (isClosed) return;
    try {
      final plant = await plantService.updatePlant(model, id: id);
      emit(UpdatePlantSuccess("action_done".tr(), plant));
      if (id == null) {
        addLocalPlant(plant);
      } else {
        updateLocalPlant(plant);
      }
    } catch (e) {
      if (isClosed) return;
      emit(UpdatePlantFail(e.toString()));
    }
  }

  void addLocalPlant(PlantModel plant) {
    plants = [...plants, plant];
    search();
  }

  void updateLocalPlant(PlantModel plant) {
    plants = plants.map((p) => p.id == plant.id ? plant : p).toList();
    search();
  }

  void deleteLocalPlant(PlantModel plant) {
    plants = plants.where((p) => p.id != plant.id).toList();
    search();
  }

  void search() {
    final filtered = plants
        .where(
          (plant) =>
              plant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              (plant.crop?.nameEn.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (plant.crop?.nameAr.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
    if (filtered.isEmpty) {
      emit(PlantsEmpty("no_plants".tr()));
    } else {
      emit(PlantsSuccess(filtered));
    }
  }
}
