import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/crops/model/add_crop_model/add_crop_model.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/features/crops/service/crops_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/crops_state.dart';
part 'states/update_crop_state.dart';
part 'states/general_crops_state.dart';

@injectable
class CropsCubit extends Cubit<GeneralCropsState> {
  CropsCubit({required this.cropsService}) : super(GeneralCropsInitial());
  final CropsService cropsService;

  List<CropModel> crops = [];
  String searchQuery = "";
  AddCropModel model = AddCropModel();

  void setModel(CropModel? crop) {
    setNameEn(crop?.nameEn);
    setNameAr(crop?.nameAr);
    setIrrigarionDays(crop?.baseIrrigationDays);
  }

  void clearModel() => model = AddCropModel();

  void setNameEn(String? nameEn) {
    model = model.copyWith(nameEn: () => nameEn);
  }

  void setNameAr(String? nameAr) {
    model = model.copyWith(nameAr: () => nameAr);
  }

  void setIrrigarionDays(int? days) {
    model = model.copyWith(baseIrrigationDays: () => days);
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    search();
  }

  Future<void> getCrops() async {
    emit(CropsLoading());
    if (isClosed) return;
    try {
      final crops = await cropsService.getCrops();
      this.crops = crops;
      search();
    } catch (e) {
      if (isClosed) return;
      emit(CropsFail(e.toString()));
    }
  }

  Future<void> updateCrop({int? id}) async {
    emit(UpdateCropLoading());
    if (isClosed) return;
    try {
      final crop = await cropsService.updateCrop(model, id: id);
      emit(UpdateCropSuccess("action_done".tr(), crop));
      if (id == null) {
        addLocalCrop(crop);
      } else {
        updateLocalCrop(crop);
      }
    } catch (e) {
      if (isClosed) return;
      emit(UpdateCropFail(e.toString()));
    }
  }

  void addLocalCrop(CropModel crop) {
    // crops.add(crop);
    crops = [crop, ...crops];
    search();
  }

  void updateLocalCrop(CropModel crop) {
    int index = crops.indexWhere((element) => element.id == crop.id);
    crops[index] = crop;
    search();
  }

  void deleteLocalCrop(CropModel crop) {
    crops.removeWhere((element) => element.id == crop.id);
    search();
  }

  void search() {
    final filtered = crops
        .where(
          (crop) =>
              crop.nameEn.toLowerCase().contains(searchQuery) ||
              crop.nameAr.toLowerCase().contains(searchQuery),
        )
        .toList();
    if (filtered.isEmpty) {
      emit(CropsEmpty("no_crops".tr()));
    } else {
      emit(CropsSuccess(filtered));
    }
  }
}
