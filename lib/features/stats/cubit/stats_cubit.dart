import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:green_mind/features/stats/model/stats_model/stats_model.dart';
import 'package:green_mind/features/stats/service/stats_service.dart';
import 'package:injectable/injectable.dart';

part 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this.statsService) : super(StatsInitial());
  final StatsService statsService;

  Future<void> getStats() async {
    emit(StatsLoading());
    if (isClosed) return;
    try {
      final stats = await statsService.getStats();
      emit(StatsSuccess(stats));
    } catch (e) {
      if (isClosed) return;
      emit(StatsFail(e.toString()));
    }
  }
}
