import 'package:bloc/bloc.dart';
import 'package:green_mind/features/diagnosing_diseases/service/diagnosing_diseases_service.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'states/diagnosing_diseases_state.dart';
part 'states/general_diagnosing_diseases_state.dart';

@injectable
class DiagnosingDiseasesCubit extends Cubit<GeneralDiagnosingDiseasesState> {
  DiagnosingDiseasesCubit({required this.diagnosingDiseasesService})
    : super(GeneralDiagnosingDiseasesInitial());
  final DiagnosingDiseasesService diagnosingDiseasesService;

  // XFile? image;

  // void onSetImage(XFile? image)=> this.image = image;

  Future<void> diagnose() async {
    emit(DiagnosingDiseasesLoading());
    try {
      if (isClosed) return;
      await Future.delayed(Duration(seconds: 2));
      emit(DiagnosingDiseasesSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(DiagnosingDiseasesFail(e.toString()));
    }
  }
}
