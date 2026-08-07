import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/features/plants/view/widgets/update_plant_disease_view.dart';
import 'package:green_mind/features/plants/view/widgets/update_plant_view.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

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
    fetchPlants(isRefresh: true);
  }

  void onUpdatePlantDisease(PlantModel plant) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          UpdatePlantDiseaseView(plant: plant, plantsCubit: plantsCubit),
    );
  }

  void onMoreTap(PlantModel plant) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: plantsCubit,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: AppConstants.padding16,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Text(
                      'more_options'.tr(),
                      style: context.tt.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    spacing: 5,
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    // spacing: 10,
                    children: [
                      TextButton(
                        onPressed: () => onUpdatePlantDisease(plant),
                        style: const ButtonStyle(
                          alignment: AlignmentDirectional.centerStart,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisSize: .min,
                          children: [
                            Icon(Icons.edit),
                            Text(
                              'update_disease_status'.tr(),
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<PlantsCubit, GeneralPlantsState>(
                        buildWhen: (_, current) =>
                            current is MarkHarvestedState,
                        builder: (context, state) {
                          Widget? loadingIndicator;
                          final bool isLoading = state is MarkHarvestedLoading;
                          var onTap = plantsCubit.markAsHarvested;
                          if (isLoading) {
                            loadingIndicator = const LoadingIndicator(size: 20);
                            onTap = (int id) async {};
                          }
                          return TextButton(
                            onPressed: () => onTap(plant.id),
                            style: const ButtonStyle(
                              alignment: AlignmentDirectional.centerStart,
                            ),
                            child: Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              children: [
                                Icon(Icons.agriculture),
                                Text(
                                  'mark_harvested'.tr(),
                                  style: context.tt.bodyMedium,
                                ),
                                ?loadingIndicator,
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<PlantsCubit, GeneralPlantsState>(
                        buildWhen: (_, current) => current is UndoHarvestState,
                        builder: (context, state) {
                          Widget? loadingIndicator;
                          final bool isLoading = state is UndoHarvestLoading;
                          var onTap = plantsCubit.undoHarvest;
                          if (isLoading) {
                            loadingIndicator = const LoadingIndicator(size: 20);
                            onTap = (int id) async {};
                          }
                          return TextButton(
                            onPressed: () => onTap(plant.id),
                            style: const ButtonStyle(
                              alignment: AlignmentDirectional.centerStart,
                            ),
                            child: Row(
                              spacing: 10,
                              mainAxisSize: .min,
                              children: [
                                Icon(Icons.undo),
                                Text(
                                  'undo_harvest'.tr(),
                                  style: context.tt.bodyMedium,
                                ),
                                ?loadingIndicator,
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void fetchPlants({bool isRefresh = false}) =>
      plantsCubit.getPlants(reset: isRefresh);

  @override
  Widget build(BuildContext context) {
    final role = Utils.userRole;
    return Scaffold(
      appBar: const MainAppBar(title: "plants"),
      drawer: const MainDrawer(),
      body: BlocListener<PlantsCubit, GeneralPlantsState>(
        listener: (context, state) {
          if (state is MarkHarvestedSuccess) {
            MainSnackBar.showSuccessMessage(context, state.message);
          } else if (state is MarkHarvestedFail) {
            MainSnackBar.showErrorMessage(context, state.error);
          } else if (state is UndoHarvestSuccess) {
            MainSnackBar.showSuccessMessage(context, state.message);
          } else if (state is UndoHarvestFail) {
            MainSnackBar.showErrorMessage(context, state.error);
          }
        },
        child: Padding(
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
                      final hasReachedMax = state.hasReachedMax;
                      final currentPage = state.currentPage;
                      return NotificationListener(
                        onNotification: (scrollInfo) {
                          // Check if we're near the bottom
                          if (scrollInfo is ScrollUpdateNotification) {
                            final maxScroll =
                                scrollInfo.metrics.maxScrollExtent;
                            final currentScroll = scrollInfo.metrics.pixels;

                            // Load more when user scrolls within 200px of bottom
                            if (maxScroll > 0 &&
                                currentScroll >= maxScroll - 200 &&
                                !plantsCubit.isLoadingMore &&
                                !hasReachedMax) {
                              plantsCubit.loadMore();
                            }
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async => fetchPlants(isRefresh: true),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              spacing: 16,
                              children: AnimationConfiguration.toStaggeredList(
                                duration: AppConstants.duration500ms,
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(child: widget),
                                    ),
                                children: [
                                  ...plants.map(
                                    (plant) => _buildPlantTile(plant, role),
                                  ),

                                  // Show loading indicator at bottom
                                  if (!hasReachedMax) ...[
                                    const Padding(
                                      padding: AppConstants.paddingV8,
                                      child: LoadingIndicator(size: 30),
                                    ),
                                  ] else if (plants.isNotEmpty &&
                                      currentPage != 1) ...[
                                    MainErrorWidget(error: 'no_more_data'.tr()),
                                  ],
                                  const SizedBox(height: 35),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (state is PlantsEmpty) {
                      return MainErrorWidget(
                        error: state.message,
                        isRefresh: true,
                        onTryAgainTap: () => fetchPlants(isRefresh: true),
                      );
                    } else if (state is PlantsFail) {
                      return MainErrorWidget(
                        error: state.error,
                        onTryAgainTap: () => fetchPlants(isRefresh: true),
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
      floatingActionButton: MainFab(onTap: () => onUpdatePlant(null)),
    );
  }

  Widget _buildPlantTile(PlantModel plant, UserRoleEnum role) {
    final hasDisease = plant.disease != null;
    final diseaseStatus = hasDisease
        ? (plant.disease?.arName ?? "---")
        : "healthy".tr();
    final bgColor = hasDisease
        ? context.cs.errorContainer
        : context.cs.primaryContainer;
    final textColor = hasDisease ? context.cs.error : context.cs.primary;
    return MainTile(
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
                        color: bgColor,
                      ),
                      child: Padding(
                        padding: AppConstants.paddingH12V4,
                        child: Text(
                          diseaseStatus,
                          style: context.tt.bodyMedium?.copyWith(
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!role.isFarmer) ...[
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
                _buildIconBtn(
                  Icons.more_vert_outlined,
                  context.cs.tertiaryContainer,
                  context.cs.tertiary,
                  () => onMoreTap(plant),
                ),
              ],
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
        padding: AppConstants.padding8,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
