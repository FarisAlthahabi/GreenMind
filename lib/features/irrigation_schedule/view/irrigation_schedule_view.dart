import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/irrigation_schedule/cubit/irrigation_schedule_cubit.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/features/irrigation_schedule/view/widgets/reschedule_irrigation_widget.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class IrrigationScheduleViewCallBacks {}

@RoutePage()
class IrrigationScheduleView extends StatelessWidget {
  const IrrigationScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<IrrigationScheduleCubit>(),
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

  @override
  void initState() {
    super.initState();
    fetchIrrigationSchedules();
  }

  void fetchIrrigationSchedules() =>
      irrigationScheduleCubit.getIrrigationSchedules();

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
              } else if (state is MarkCompletedSuccess) {
                MainSnackBar.showSuccessMessage(context, state.message);
              } else if (state is UndoIrrigationSuccess) {
                MainSnackBar.showSuccessMessage(context, state.message);
              }
            },
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                spacing: 20,
                crossAxisAlignment: .start,
                children: [
                  MainTextField(
                    hintText: "search_for_irrigation_schedule",
                    prefixIcon: const Icon(Icons.search),
                    onChanged: irrigationScheduleCubit.setSearchQuery,
                  ),
                  Expanded(
                    child:
                        BlocBuilder<
                          IrrigationScheduleCubit,
                          GeneralIrrigationScheduleState
                        >(
                          buildWhen: (_, current) =>
                              current is IrrigationScheduleState,
                          builder: (context, state) {
                            if (state is IrrigationScheduleLoading) {
                              return const Align(child: LoadingIndicator());
                            } else if (state is IrrigationScheduleSuccess) {
                              final schedules = state.schedules;
                              return RefreshIndicator(
                                onRefresh: () async =>
                                    fetchIrrigationSchedules(),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    spacing: 16,
                                    children:
                                        AnimationConfiguration.toStaggeredList(
                                          duration: AppConstants.duration500ms,
                                          childAnimationBuilder: (widget) =>
                                              SlideAnimation(
                                                horizontalOffset: 50.0,
                                                child: FadeInAnimation(
                                                  child: widget,
                                                ),
                                              ),
                                          children: [
                                            ...schedules.map(
                                              _buildScheduleTile,
                                            ),
                                            const SizedBox(height: 50),
                                          ],
                                        ),
                                  ),
                                ),
                              );
                            } else if (state is IrrigationScheduleEmpty) {
                              return MainErrorWidget(
                                error: state.message,
                                isRefresh: true,
                                onTryAgainTap: fetchIrrigationSchedules,
                              );
                            } else if (state is IrrigationScheduleFail) {
                              return MainErrorWidget(
                                error: state.error,
                                onTryAgainTap: fetchIrrigationSchedules,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildScheduleTile(IrrigationScheduleModel schedule) {
    final isOverridden = schedule.isManualOverride;
    final isCompleted = schedule.actualDate != null;
    final status = isCompleted ? "completed" : "incomming";
    final statusColor = isCompleted ? Colors.green : Colors.yellow;

    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: .all(
          width: 0.2,
          color: isOverridden ? context.cs.primary : context.cs.onSurface,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  "${"plant".tr()}: ${schedule.plant?.name ?? schedule.plantId.toString()}",
                  style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                ),
              ),
              if (isOverridden)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppConstants.borderRadius20,
                    color: context.cs.primaryContainer,
                  ),
                  child: Padding(
                    padding: AppConstants.paddingH12V4,
                    child: Text(
                      "manual_override".tr(),
                      style: context.tt.bodyMedium,
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
                  child: Text(status.tr(), style: context.tt.bodyMedium),
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
              Spacer(),
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
              // if (isCompleted)
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
                Icon(Icons.note, size: 16, color: context.cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${"notes".tr()}: ${schedule.notes}",
                    style: context.tt.bodyMedium,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppConstants.borderRadius10,
      ),
      child: Padding(
        padding: AppConstants.padding8,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          child: isLoading
              ? const LoadingIndicator(size: 20)
              : Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
