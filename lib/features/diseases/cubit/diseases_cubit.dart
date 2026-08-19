import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:green_mind/features/diseases/model/add_disease_model/add_disease_model.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/features/diseases/service/diseases_service.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/general_diseases_state.dart';
part 'states/diseases_state.dart';
part 'states/update_disease_state.dart';

@injectable
class DiseasesCubit extends Cubit<GeneralDiseasesState> {
  DiseasesCubit({required this.diseasesService}) : super(GeneralDiseasesInitial());
  final DiseasesService diseasesService;

  List<DiseaseModel> diseases = [];
  String searchQuery = "";
  AddDiseaseModel model = AddDiseaseModel();

  void setModel(DiseaseModel? disease) {
    setTechnicalName(disease?.technicalName);
    setEnName(disease?.enName);
    setArName(disease?.arName);
  }

  void clearModel() => model = AddDiseaseModel();

  void setTechnicalName(String? technicalName) {
    model = model.copyWith(technicalName: () => technicalName);
  }

  void setEnName(String? enName) {
    model = model.copyWith(enName: () => enName);
  }

  void setArName(String? arName) {
    model = model.copyWith(arName: () => arName);
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    search();
  }

  Future<void> getDiseases() async {
    emit(DiseasesLoading());
    if (isClosed) return;
    try {
      final diseases = await diseasesService.getDiseases();
      this.diseases = diseases;
      search();
    } catch (e) {
      if (isClosed) return;
      emit(DiseasesFail(e.toString()));
    }
  }

  Future<void> updateDisease({int? id}) async {
    emit(UpdateDiseaseLoading());
    if (isClosed) return;
    try {
      final disease = await diseasesService.updateDisease(model, id: id);
      emit(UpdateDiseaseSuccess("action_done".tr(), disease));
      if (id == null) {
        addLocalDisease(disease);
      } else {
        updateLocalDisease(disease);
      }
    } catch (e) {
      if (isClosed) return;
      emit(UpdateDiseaseFail(e.toString()));
    }
  }

  void addLocalDisease(DiseaseModel disease) {
    diseases = [disease, ...diseases];
    // diseases.add(disease);
    search();
  }

  void updateLocalDisease(DiseaseModel disease) {
    int index = diseases.indexWhere((element) => element.id == disease.id);
    diseases[index] = disease;
    search();
  }

  void deleteLocalDisease(DiseaseModel disease) {
    diseases.removeWhere((element) => element.id == disease.id);
    search();
  }

  void search() {
    final filtered = diseases
        .where(
          (disease) =>
              disease.enName.toLowerCase().contains(searchQuery) ||
              disease.arName.toLowerCase().contains(searchQuery) ||
              disease.technicalName.toLowerCase().contains(searchQuery),
        )
        .toList();
    if (filtered.isEmpty) {
      emit(DiseasesEmpty("no_diseases".tr()));
    } else {
      emit(DiseasesSuccess(filtered));
    }
  }
}