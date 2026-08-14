import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_response_model/diagnose_response_model.dart';
import 'package:green_mind/features/diagnosing_diseases/service/diagnosing_diseases_service.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/view/plants_view.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/diagnosing_diseases_state.dart';
part 'states/general_diagnosing_diseases_state.dart';
part 'states/diagnoses_diseases_state.dart';

@injectable
class DiagnosingDiseasesCubit extends Cubit<GeneralDiagnosingDiseasesState> {
  DiagnosingDiseasesCubit({required this.service})
    : super(GeneralDiagnosingDiseasesInitial());
  final DiagnosingDiseasesService service;

  XFile? image;
  PlantModel? plant;

  List<DiagnoseModel> diagnoses = [];
  String searchQuery = "";
  PlantModel? plantFilter;
  UserModel? userFilter;
  HealthStatusEnum? selectedHealthStatus;

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool hasReachedMax = false;

  Timer? _debounceTimer;

  void onSetImage(XFile? image) => this.image = image;
  void setPlant(PlantModel? plant) => this.plant = plant;

  void setUserFilter(UserModel? user) {
    userFilter = user;
    getDiagnoses(reset: true);
  }

  void setPlantFilter(PlantModel? plant) {
    plantFilter = plant;
    getDiagnoses(reset: true);
  }

  void setHealthStatusFilter(HealthStatusEnum? status) {
    if (status != null) {
      selectedHealthStatus = status;
      getDiagnoses(reset: true);
    }
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.duration1s, () {
      getDiagnoses(reset: true);
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> diagnose() async {
    if (image == null) return;
    emit(DiagnosingDiseasesLoading());
    try {
      if (isClosed) return;
      final diagnose = await service.diagnoiseDesease(
        image!,
        plantId: plant?.id,
      );
      emit(DiagnosingDiseasesSuccess(diagnose));
    } catch (e) {
      if (isClosed) return;
      emit(DiagnosingDiseasesFail(e.toString()));
    }
  }

  Future<void> getDiagnoses({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      hasReachedMax = false;
      diagnoses.clear();
      emit(DiagnosesDiseasesLoading());
    } else if (isLoadingMore || hasReachedMax) {
      return;
    }

    if (isClosed) return;

    try {
      isLoadingMore = true;

      final paginatedData = await service.getDiagnoses(
        page: currentPage,
        search: searchQuery,
        plantId: plantFilter?.id,
        userId: userFilter?.id,
        isHealthy: selectedHealthStatus?.value,
      );

      lastPage = paginatedData.pagination.lastPage;
      currentPage = paginatedData.pagination.currentPage;

      if (currentPage >= lastPage) {
        hasReachedMax = true;
      }

      if (reset) {
        diagnoses = paginatedData.data;
      } else {
        diagnoses = [...diagnoses, ...paginatedData.data];
      }

      isLoadingMore = false;
      emitDiagnoses();
    } catch (e) {
      isLoadingMore = false;
      if (isClosed) return;
      emit(DiagnosesDiseasesFail(e.toString()));
    }
  }

  void emitDiagnoses() {
    if (diagnoses.isEmpty) {
      emit(DiagnosesDiseasesEmpty("no_diagnoses".tr()));
    } else {
      emit(
        DiagnosesDiseasesSuccess(
          diagnoses,
          hasReachedMax: hasReachedMax,
          currentPage: currentPage,
        ),
      );
    }
  }
}
