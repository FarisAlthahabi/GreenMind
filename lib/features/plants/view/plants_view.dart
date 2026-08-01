import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/view/widgets/update_plant_view.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class PlantsViewCallBacks {}

@RoutePage()
class PlantsView extends StatelessWidget {
  const PlantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<PlantsCubit>(),
      child: const PlantsPage(),
    );
  }
}

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage>
    implements PlantsViewCallBacks {
  late final PlantsCubit plantsCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  void onDeletePlant(PlantModel plant) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InsureDeleteWidget(
        item: plant,
        onSuccess: () => plantsCubit.deleteLocalPlant(plant),
      ),
    );
  }

  void onUpdatePlant(PlantModel? plant) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          UpdatePlantView(plantsCubit: plantsCubit, plant: plant),
    );
  }

  void fetchPlants() => plantsCubit.getPlants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "plants"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_for_plant",
              prefixIcon: Icon(Icons.search),
              onChanged: plantsCubit.setSearchQuery,
            ),
            Expanded(
              child: BlocBuilder<PlantsCubit, GeneralPlantsState>(
                buildWhen: (_, current) => current is PlantsState,
                builder: (context, state) {
                  if (state is PlantsLoading) {
                    return Align(child: LoadingIndicator());
                  } else if (state is PlantsSuccess) {
                    final plants = state.plants;
                    return RefreshIndicator(
                      onRefresh: () async => fetchPlants(),
                      child: SingleChildScrollView(
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
                              ...plants.map(_buildPlantTile),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is PlantsEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      isRefresh: true,
                      onTryAgainTap: fetchPlants,
                    );
                  } else if (state is PlantsFail) {
                    return MainErrorWidget(
                      error: state.error,
                      onTryAgainTap: fetchPlants,
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
      floatingActionButton: MainFab(onTap: () => onUpdatePlant(null)),
    );
  }

  Widget _buildPlantTile(PlantModel plant) {
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  spacing: 10,
                  children: [
                    Text(
                      plant.name,
                      style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.borderRadius20,
                        color: context.cs.primaryContainer,
                      ),
                      child: Padding(
                        padding: AppConstants.paddingH12V4,
                        child: Text(plant.healthStatus ?? "---"),
                      ),
                    ),
                  ],
                ),
              ),
              _buildIconBtn(
                Icons.edit,
                context.cs.secondaryContainer,
                context.cs.secondary,
                () => onUpdatePlant(plant),
              ),
              _buildIconBtn(
                Icons.delete,
                context.cs.errorContainer,
                context.cs.error,
                () => onDeletePlant(plant),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Text("${"type".tr()}: ${plant.crop?.nameAr ?? "---"}"),
              ),
              Expanded(child: Text("${"quantity".tr()}: ${plant.quantity}")),
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  "${"planting_date".tr()}: ${plant.plantingDate?.formatYYYYMMDD}",
                ),
              ),
              Expanded(
                child: Text(
                  "${"harvest_date".tr()}: ${plant.harvestDate?.formatYYYYMMDD ?? "unknown".tr()}",
                ),
              ),
              // Expanded(child: Text("${"notes".tr()}: ${plant.notes}")),
            ],
          ),
          if (plant.notes != null) ...[
            const Divider(height: 0),
            Center(child: Text("${"notes".tr()}: ${plant.notes}")),
          ],
        ],
      ),
    );
  }

  Widget _buildIconBtn(
    IconData icon,
    Color bgColor,
    Color color,
    void Function() onTap,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppConstants.borderRadius10,
      ),
      child: Padding(
        padding: AppConstants.padding10,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
