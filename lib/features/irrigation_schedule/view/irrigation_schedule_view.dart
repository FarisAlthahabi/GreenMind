import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/irrigation_schedule/cubit/irrigation_schedule_cubit.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/features/irrigation_schedule/view/widgets/irrigation_schedule_filters_view.dart';
import 'package:green_mind/features/irrigation_schedule/view/widgets/reschedule_irrigation_widget.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

enum IrrigationScheduleStatus implements DropDownItemModel {
  all,
  upcoming,
  completed;

  bool get isAll => this == .all;
  bool get isUpcoming => this == .upcoming;
  bool get isCompleted => this == .completed;

  bool? get isIrrigated {
    switch (this) {
      case all:
        return null;
      case upcoming:
        return false;
      case completed:
        return true;
    }
  }

  @override
  String get displayName => name.tr();

  static IrrigationScheduleStatus fromString(String? value) {
    switch (value) {
      case 'all':
        return all;
      case 'upcoming':
        return upcoming;
      case 'completed':
        return completed;
      default:
        return all;
    }
  }

  @override
  String? get description => null;

  @override
  int get id => index;

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => null;
}

abstract class IrrigationScheduleViewCallBacks {}

@RoutePage()
class IrrigationScheduleView extends StatelessWidget {
  const IrrigationScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => get<IrrigationScheduleCubit>()),
        BlocProvider(create: (context) => get<PlantsCubit>()),
      ],
      child: const IrrigationSchedulePage(),
    );
  }
}

class IrrigationSchedulePage extends StatefulWidget {
  const IrrigationSchedulePage({super.key});

  @override
  State<IrrigationSchedulePage> createState() => _IrrigationSchedulePageState();
}

class _IrrigationSchedulePageState extends State<IrrigationSchedulePage>
    implements IrrigationScheduleViewCallBacks {
  late final IrrigationScheduleCubit irrigationScheduleCubit = context.read();
  late final PlantsCubit plantsCubit = context.read();

  void fetchPlants() => plantsCubit.getPlants(reset: true, perPage: 10000000);

  @override
  void initState() {
    super.initState();
    fetchIrrigationSchedules(isRefresh: true);
    fetchPlants();
  }

  void fetchIrrigationSchedules({bool isRefresh = false}) =>
      irrigationScheduleCubit.getIrrigationSchedules(reset: isRefresh);

  void onMarkCompleted(IrrigationScheduleModel schedule) {
    irrigationScheduleCubit.markCompleted(schedule.id);
  }

  void onUndoLastIrrigation(IrrigationScheduleModel schedule) {
    irrigationScheduleCubit.undoLastIrrigation(schedule.plantId);
  }

  void onUpdateSchedule(IrrigationScheduleModel schedule) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RescheduleIrrigationView(
        scheduleCubit: irrigationScheduleCubit,
        schedule: schedule,
      ),
    );
  }

  void onFilterTap() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: irrigationScheduleCubit),
            BlocProvider.value(value: plantsCubit),
          ],
          child: const IrrigationScheduleFiltersView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "irrigation_schedules"),
      drawer: const MainDrawer(),
      body:
          BlocListener<IrrigationScheduleCubit, GeneralIrrigationScheduleState>(
            listener: (context, state) {
              if (state is MarkCompletedFail) {
                MainSnackBar.showErrorMessage(context, state.error);
              } else if (state is UndoIrrigationFail) {
                MainSnackBar.showErrorMessage(context, state.error);
              } else if (state is RescheduleIrrigationFail) {
                MainSnackBar.showErrorMessage(context, state.error);
              } else if (state is MarkCompletedSuccess) {
                MainSnackBar.showSuccessMessage(context, state.message);
              } else if (state is UndoIrrigationSuccess) {
                MainSnackBar.showSuccessMessage(context, state.message);
              } else if (state is RescheduleIrrigationSuccess) {
                MainSnackBar.showSuccessMessage(context, state.message);
              }
            },
            child: Column(
              // spacing: 20,
              crossAxisAlignment: .start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: AppConstants.paddingH16,
                  child: MainTextField(
                    hintText: "search_for_irrigation_schedule",
                    prefixIcon: const Icon(Icons.search),
                    onChanged: irrigationScheduleCubit.setSearchQuery,
                  ),
                ),
                _buildSchdualesListView(),
              ],
            ),
          ),
      floatingActionButton: MainFab(
        icon: Icons.filter_alt_outlined,
        onTap: onFilterTap,
      ),
    );
  }

  Widget _buildSchdualesListView() {
    return Expanded(
      child:
          BlocBuilder<IrrigationScheduleCubit, GeneralIrrigationScheduleState>(
            buildWhen: (_, current) => current is IrrigationScheduleState,
            builder: (context, state) {
              if (state is IrrigationScheduleLoading &&
                  irrigationScheduleCubit.schedules.isEmpty) {
                return const Align(child: LoadingIndicator());
              } else if (state is IrrigationScheduleSuccess) {
                final schedules = state.schedules;
                final hasReachedMax = state.hasReachedMax;
                final currentPage = state.currentPage;

                return NotificationListener(
                  onNotification: (scrollInfo) {
                    if (scrollInfo is ScrollUpdateNotification) {
                      final maxScroll = scrollInfo.metrics.maxScrollExtent;
                      final currentScroll = scrollInfo.metrics.pixels;

                      if (maxScroll > 0 &&
                          currentScroll >= maxScroll - 200 &&
                          !irrigationScheduleCubit.isLoadingMore &&
                          !irrigationScheduleCubit.hasReachedMax) {
                        irrigationScheduleCubit.loadMore();
                      }
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        fetchIrrigationSchedules(isRefresh: true),
                    child: SingleChildScrollView(
                      padding: AppConstants.padding16,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        spacing: 16,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: AppConstants.duration500ms,
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            ...schedules.map(_buildScheduleTile),
                            // Show loading indicator at bottom
                            if (!hasReachedMax) ...[
                              const Padding(
                                padding: AppConstants.paddingV8,
                                child: LoadingIndicator(size: 30),
                              ),
                            ] else if (hasReachedMax &&
                                schedules.isNotEmpty &&
                                currentPage != 1) ...[
                              MainErrorWidget(
                                error: 'no_more_data'.tr(),
                                isRefresh: true,
                              ),
                            ],
                            const SizedBox(height: 35),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is IrrigationScheduleEmpty) {
                return MainErrorWidget(
                  error: state.message,
                  isRefresh: true,
                  onTryAgainTap: () =>
                      fetchIrrigationSchedules(isRefresh: true),
                );
              } else if (state is IrrigationScheduleFail) {
                return MainErrorWidget(
                  error: state.error,
                  onTryAgainTap: () =>
                      fetchIrrigationSchedules(isRefresh: true),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
    );
  }

  Widget _buildScheduleTile(IrrigationScheduleModel schedule) {
    final isOverridden = schedule.isManualOverride;
    final isCompleted = schedule.actualDate != null;
    final status = isCompleted ? "completed" : "incomming";
    final textStatusColor = isCompleted
        ? context.cs.primary
        : context.cs.tertiary;
    final statusColor = isCompleted
        ? context.cs.primaryContainer
        : context.cs.tertiaryContainer;

    return MainTile(
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  schedule.plant?.name ?? schedule.plantId.toString(),
                  style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                ),
              ),
              if (isOverridden)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppConstants.borderRadius20,
                    color: context.cs.tertiaryContainer,
                  ),
                  child: Padding(
                    padding: AppConstants.paddingH12V4,
                    child: Text(
                      "manual_override".tr(),
                      style: context.tt.bodyMedium?.copyWith(
                        color: context.cs.tertiary,
                      ),
                    ),
                  ),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: AppConstants.borderRadius20,
                  color: statusColor,
                ),
                child: Padding(
                  padding: AppConstants.paddingH12V4,
                  child: Text(
                    status.tr(),
                    style: context.tt.bodyMedium?.copyWith(
                      color: textStatusColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 5,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: context.cs.onSurfaceVariant,
              ),
              Text("${"recommended_date".tr()}:", style: context.tt.bodyMedium),
              const Spacer(),
              Text(
                schedule.recommendedDate.formatYYYYMMDD,
                style: context.tt.bodyMedium,
              ),
            ],
          ),
          if (schedule.actualDate != null)
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: context.cs.primary),
                const SizedBox(width: 8),
                Text(
                  "${"actual_date".tr()}: ${schedule.actualDate?.formatYYYYMMDD}",
                  style: context.tt.bodyMedium?.copyWith(
                    color: context.cs.primary,
                  ),
                ),
              ],
            ),
          Row(
            spacing: 10,
            mainAxisAlignment: .end,
            children: [
              if (!isCompleted)
                BlocBuilder<
                  IrrigationScheduleCubit,
                  GeneralIrrigationScheduleState
                >(
                  buildWhen: (_, current) => current is MarkCompletedState,
                  builder: (context, state) {
                    final bool isLoading = state is MarkCompletedLoading;
                    return _buildIconBtn(
                      Icons.check_circle,
                      context.cs.primaryContainer,
                      context.cs.primary,
                      () => onMarkCompleted(schedule),
                      isLoading: isLoading,
                    );
                  },
                ),
              if (isCompleted)
                BlocBuilder<
                  IrrigationScheduleCubit,
                  GeneralIrrigationScheduleState
                >(
                  buildWhen: (_, current) => current is UndoIrrigationState,
                  builder: (context, state) {
                    final bool isLoading = state is UndoIrrigationLoading;
                    return _buildIconBtn(
                      Icons.undo,
                      context.cs.tertiaryContainer,
                      context.cs.tertiary,
                      () => onUndoLastIrrigation(schedule),
                      isLoading: isLoading,
                    );
                  },
                ),
              _buildIconBtn(
                Icons.edit,
                context.cs.secondaryContainer,
                context.cs.secondary,
                () => onUpdateSchedule(schedule),
              ),
            ],
          ),
          if (schedule.notes != null) ...[
            const Divider(height: 0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${"notes".tr()}: ${schedule.notes}",
                    style: context.tt.bodyMedium,
                    textAlign: .center,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconBtn(
    IconData icon,
    Color bgColor,
    Color color,
    void Function() onTap, {
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppConstants.borderRadius10,
        ),
        child: Padding(
          padding: AppConstants.padding8,
          child: isLoading
              ? const LoadingIndicator(size: 20)
              : Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
