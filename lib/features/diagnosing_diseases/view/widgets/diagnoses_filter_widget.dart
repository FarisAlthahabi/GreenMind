// diagnoses_filter_widget.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/view/plants_view.dart';
import 'package:green_mind/features/users/cubit/users_cubit.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';

class DiagnosesFilterWidget extends StatefulWidget {
  const DiagnosesFilterWidget({super.key});

  @override
  State<DiagnosesFilterWidget> createState() => _DiagnosesFilterWidgetState();
}

class _DiagnosesFilterWidgetState extends State<DiagnosesFilterWidget> {
  late final DiagnosingDiseasesCubit diagnosingCubit = context.read();
  late final UsersCubit usersCubit = context.read();
  late final PlantsCubit plantsCubit = context.read();

  void fetchUsers() => usersCubit.getUsers();
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
          MainDropDownWidget<HealthStatusEnum>(
            items: HealthStatusEnum.values,
            showAllOption: false,
            selectedValue: diagnosingCubit.selectedHealthStatus,
            textColor: context.cs.onSurfaceVariant,
            prefixIcon: Icons.health_and_safety_outlined,
            text: "select_health_status".tr(),
            onChanged: diagnosingCubit.setHealthStatusFilter,
            hasSearch: false,
          ),
          _buildUserDropDown(),
          _buildPlantDropDown(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildUserDropDown() {
    return BlocBuilder<UsersCubit, GeneralUsersState>(
      buildWhen: (_, current) => current is UsersState,
      builder: (context, state) {
        if (state is UsersLoading) {
          return const LoadingIndicator();
        } else if (state is UsersSuccess) {
          return MainDropDownWidget<UserModel>(
            prefixIcon: Icons.person_outline,
            items: state.users,
            selectedValue: diagnosingCubit.userFilter,
            text: "select_user".tr(),
            textColor: context.cs.onSurfaceVariant,
            onChanged: diagnosingCubit.setUserFilter,
            allOptionText: "select_user",
          );
        } else if (state is UsersEmpty) {
          return MainErrorWidget(
            error: state.message,
            isRefresh: true,
            onTryAgainTap: () => fetchUsers(),
          );
        } else if (state is UsersFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: () => fetchUsers(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

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
            selectedValue: diagnosingCubit.plantFilter,
            text: "select_plant".tr(),
            textColor: context.cs.onSurfaceVariant,
            onChanged: diagnosingCubit.setPlantFilter,
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
