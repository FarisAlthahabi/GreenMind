import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/crops/cubit/crops_cubit.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/view/plants_view.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';

enum HarvestStatusEnum implements DropDownItemModel {
  all,
  harvested,
  unharvested;

  bool get isAll => this == .all;
  bool get isHarvested => this == harvested;
  bool get isUnharvested => this == unharvested;

  bool? get value {
    switch (this) {
      case .all:
        return null;
      case harvested:
        return true;
      case unharvested:
        return false;
    }
  }

  @override
  String get displayName => name.tr();

  @override
  String? get description => null;

  @override
  int get id => index;

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => null;
}

class PlantsFilterWidget extends StatefulWidget {
  const PlantsFilterWidget({super.key});

  @override
  State<PlantsFilterWidget> createState() => _PlantsFilterWidgetState();
}

class _PlantsFilterWidgetState extends State<PlantsFilterWidget> {
  late final PlantsCubit plantsCubit = context.read();
  late final CropsCubit cropsCubit = context.read();

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
          MainDropDownWidget<HarvestStatusEnum>(
            items: HarvestStatusEnum.values,
            showAllOption: false,
            selectedValue: plantsCubit.selectedHarvestStatus,
            textColor: context.cs.onSurfaceVariant,
            prefixIcon: Icons.agriculture_outlined,
            text: "select_harvest_status".tr(),
            onChanged: plantsCubit.setHarvestStatusFilter,
            hasSearch: false,
          ),
          MainDropDownWidget<HealthStatusEnum>(
            items: HealthStatusEnum.values,
            showAllOption: false,
            selectedValue: plantsCubit.selectedHealthStatus,
            textColor: context.cs.onSurfaceVariant,
            prefixIcon: Icons.health_and_safety_outlined,
            text: "select_health_status".tr(),
            onChanged: plantsCubit.setHealthStatusFilter,
            hasSearch: false,
          ),
          _buildCropsDropDown(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCropsDropDown() {
    return BlocBuilder<CropsCubit, GeneralCropsState>(
      buildWhen: (_, current) => current is CropsState,
      builder: (context, state) {
        if (state is CropsLoading) {
          return const LoadingIndicator();
        } else if (state is CropsSuccess) {
          return MainDropDownWidget(
            prefixIcon: Icons.local_florist_outlined,
            items: state.crops,
            selectedValue: plantsCubit.cropFilter,
            text: "select_crop_type".tr(),
            textColor: context.cs.onSurfaceVariant,
            onChanged: plantsCubit.setCropFilter,
            allOptionText: "select_crop_type",
          );
        } else if (state is CropsEmpty) {
          return MainErrorWidget(
            error: state.message,
            isRefresh: true,
            onTryAgainTap: cropsCubit.getCrops,
          );
        } else if (state is CropsFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: cropsCubit.getCrops,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
