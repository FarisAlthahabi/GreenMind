import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/irrigation_schedule/cubit/irrigation_schedule_cubit.dart';
import 'package:green_mind/features/irrigation_schedule/view/irrigation_schedule_view.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_date_picker.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';

class IrrigationScheduleFiltersView extends StatefulWidget {
  const IrrigationScheduleFiltersView({super.key});

  @override
  State<IrrigationScheduleFiltersView> createState() =>
      _IrrigationScheduleFiltersViewState();
}

class _IrrigationScheduleFiltersViewState
    extends State<IrrigationScheduleFiltersView> {
  late final PlantsCubit plantsCubit = context.read();
  late final IrrigationScheduleCubit irrigationScheduleCubit = context.read();

  void fetchPlants() => plantsCubit.getPlants(reset: true, perPage: 10000000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: .min,
        children: [
          Text("filters".tr(), style: context.tt.headlineMedium),
          // ?_buildClearFiltersButton(),
          MainDropDownWidget<IrrigationScheduleStatus>(
            items: IrrigationScheduleStatus.values,
            text: "select_status".tr(),
            selectedValue: irrigationScheduleCubit.selectedStatus,
            onChanged: irrigationScheduleCubit.setStatus,
            prefixIcon: Icons.check_circle_outline,
            hasSearch: false,
            showAllOption: false,
          ),
          MainDatePicker(
            onDateSelected: irrigationScheduleCubit.setRecommendedDateFilter,
            selectedDate: irrigationScheduleCubit.recommendedDateFilter,
          ),
          _buildPlantDropDown(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Widget? _buildClearFiltersButton() {
  //   final hasActiveFilters =
  //       irrigationScheduleCubit.selectedStatus !=
  //           IrrigationScheduleStatus.all ||
  //       irrigationScheduleCubit.plantFilter != null ||
  //       irrigationScheduleCubit.recommendedDateFilter != null;

  //   if (!hasActiveFilters) return null;

  //   return TextButton.icon(
  //     onPressed: () {
  //       irrigationScheduleCubit.clearFilters();
  //       // Navigator.pop(context);
  //     },
  //     icon: const Icon(Icons.clear_all_outlined, size: 20),
  //     label: Text(
  //       "clear_filters".tr(),
  //       style: context.tt.labelLarge?.copyWith(
  //         color: context.cs.error,
  //         fontWeight: .w600,
  //       ),
  //     ),
  //     style: TextButton.styleFrom(
  //       foregroundColor: context.cs.error,
  //       padding: AppConstants.paddingH12V8,
  //       minimumSize: Size.zero,
  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //     ),
  //   );
  // }

  Widget _buildPlantDropDown() {
    return BlocBuilder<PlantsCubit, GeneralPlantsState>(
      buildWhen: (_, current) => current is PlantsState,
      builder: (context, state) {
        if (state is PlantsLoading) {
          return const LoadingIndicator();
        } else if (state is PlantsSuccess) {
          return MainDropDownWidget<PlantModel>(
            prefixIcon: Icons.local_florist_outlined,
            items: state.plants,
            selectedValue: irrigationScheduleCubit.plantFilter,
            text: "select_plant".tr(),
            textColor: context.cs.onSurfaceVariant,
            onChanged: irrigationScheduleCubit.setPlantFilter,
            allOptionText: "select_plant",
          );
        } else if (state is PlantsEmpty) {
          return MainErrorWidget(
            error: state.message,
            isRefresh: true,
            onTryAgainTap: () => fetchPlants(),
          );
        } else if (state is PlantsFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: () => fetchPlants(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
