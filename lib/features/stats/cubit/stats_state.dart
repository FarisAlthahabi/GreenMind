part of 'stats_cubit.dart';

sealed class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

final class StatsInitial extends StatsState {}

final class StatsLoading extends StatsState {}

final class StatsSuccess extends StatsState {
  final StatsModel stats;

  const StatsSuccess(this.stats);
}

final class StatsFail extends StatsState {
  final String error;

  const StatsFail(this.error);
}
