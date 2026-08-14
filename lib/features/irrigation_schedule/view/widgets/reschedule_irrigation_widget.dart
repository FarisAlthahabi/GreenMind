import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/irrigation_schedule/cubit/irrigation_schedule_cubit.dart';
import 'package:green_mind/features/irrigation_schedule/model/irrigation_schedule_model/irrigation_schedule_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_date_picker.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';

class RescheduleIrrigationView extends StatelessWidget {
  const RescheduleIrrigationView({
    super.key,
    required this.schedule,
    this.onSuccess,
    required this.scheduleCubit,
  });
  final IrrigationScheduleCubit scheduleCubit;
  final IrrigationScheduleModel schedule;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: scheduleCubit,
      child: RescheduleIrrigationWidget(
        schedule: schedule,
        onSuccess: onSuccess,
      ),
    );
  }
}

class RescheduleIrrigationWidget extends StatefulWidget {
  const RescheduleIrrigationWidget({
    super.key,
    required this.schedule,
    this.onSuccess,
  });

  final IrrigationScheduleModel schedule;
  final VoidCallback? onSuccess;

  @override
  State<RescheduleIrrigationWidget> createState() =>
      _RescheduleIrrigationWidgetState();
}

class _RescheduleIrrigationWidgetState
    extends State<RescheduleIrrigationWidget> {
  late final IrrigationScheduleCubit scheduleCubit = context.read();

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius20,
        side: BorderSide(color: context.cs.outline, width: 0.3),
      ),
      backgroundColor: context.cs.surface,
      contentPadding: AppConstants.padding30,
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Text(
              "update_irrigation".tr(),
              style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
            ),
          ),
          _buildCloseIcon(),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            MainDatePicker(onDateSelected: scheduleCubit.setNewScheduleDate),
            const SizedBox(height: 5),
            Row(
              spacing: 10,
              mainAxisAlignment: .end,
              children: [
                Expanded(
                  child: MainActionButton(
                    padding: AppConstants.padding16,
                    buttonColor: Colors.transparent,
                    border: .all(width: 0.3, color: context.cs.outline),
                    textColor: context.cs.onSurface,
                    fontWeight: .bold,
                    text: "cancel".tr(),
                    onPressed: () => onCancelTap(context),
                  ),
                ),
                Expanded(
                  child:
                      BlocConsumer<
                        IrrigationScheduleCubit,
                        GeneralIrrigationScheduleState
                      >(
                        buildWhen: (_, current) =>
                            current is RescheduleIrrigationState,
                        listener: (context, state) {
                          if (state is RescheduleIrrigationSuccess) {
                            widget.onSuccess?.call();
                            onCancelTap(context);
                            MainSnackBar.showSuccessMessage(
                              context,
                              state.message,
                            );
                          } else if (state is RescheduleIrrigationFail) {
                            MainSnackBar.showErrorMessage(context, state.error);
                          }
                        },
                        builder: (context, state) {
                          return MainActionButton(
                            padding: AppConstants.padding16,
                            fontWeight: .bold,
                            onPressed: () => scheduleCubit.rescheduleIrrigation(
                              widget.schedule.id,
                            ),
                            text: "save".tr(),
                            isLoading: state is RescheduleIrrigationLoading,
                          );
                        },
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return InkWell(
      onTap: () => onCancelTap(context),
      child: Icon(Icons.close, size: 20),
    );
  }
}
