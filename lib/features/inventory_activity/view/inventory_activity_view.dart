// inventory_activity_view.dart
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/inventory_activity/cubit/inventory_activity_cubit.dart';
import 'package:green_mind/features/inventory_activity/model/inventory_activity_model/inventory_activity_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

@RoutePage()
class InventoryActivityView extends StatelessWidget {
  const InventoryActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          get<InventoryActivityCubit>()..getActivities(reset: true),
      child: const InventoryActivityPage(),
    );
  }
}

class InventoryActivityPage extends StatefulWidget {
  const InventoryActivityPage({super.key});

  @override
  State<InventoryActivityPage> createState() => _InventoryActivityPageState();
}

class _InventoryActivityPageState extends State<InventoryActivityPage> {
  late final InventoryActivityCubit activityCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchActivities(isRefresh: true);
  }

  void fetchActivities({bool isRefresh = false}) =>
      activityCubit.getActivities(reset: isRefresh);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "inventory_activities"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_activities".tr(),
              prefixIcon: const Icon(Icons.search),
              onChanged: activityCubit.setSearchQuery,
            ),
            Expanded(
              child:
                  BlocBuilder<
                    InventoryActivityCubit,
                    GeneralInventoryActivityState
                  >(
                    buildWhen: (_, current) => current is ActivitiesState,
                    builder: (context, state) {
                      if (state is ActivitiesLoading &&
                          activityCubit.activities.isEmpty) {
                        return const Align(child: LoadingIndicator());
                      } else if (state is ActivitiesSuccess) {
                        final activities = state.activities;
                        final hasReachedMax = state.hasReachedMax;
                        final currentPage = state.currentPage;

                        return NotificationListener<ScrollUpdateNotification>(
                          onNotification: (scrollInfo) {
                            final maxScroll =
                                scrollInfo.metrics.maxScrollExtent;
                            final currentScroll = scrollInfo.metrics.pixels;

                            if (maxScroll > 0 &&
                                currentScroll >= maxScroll - 200 &&
                                !activityCubit.isLoadingMore &&
                                !hasReachedMax) {
                              activityCubit.loadMore();
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async =>
                                fetchActivities(isRefresh: true),
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
                                        ...activities.map(_buildActivityTile),
                                        if (!hasReachedMax &&
                                            activities.isNotEmpty) ...[
                                          const Padding(
                                            padding: AppConstants.paddingV8,
                                            child: LoadingIndicator(size: 30),
                                          ),
                                        ] else if (hasReachedMax &&
                                            activities.isNotEmpty &&
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
                      } else if (state is ActivitiesEmpty) {
                        return MainErrorWidget(
                          error: state.message,
                          isRefresh: true,
                          onTryAgainTap: () => fetchActivities(isRefresh: true),
                        );
                      } else if (state is ActivitiesFail) {
                        return MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: () => fetchActivities(isRefresh: true),
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
    );
  }

  Widget _buildActivityTile(InventoryActivityModel activity) {
    final inventory = activity.inventory;
    final plant = inventory?.plant;
    final plantName = plant?.name ?? "unknown_plant".tr();
    final storageLocation = inventory?.storageLocation ?? "---";
    final userName = activity.user?.name ?? "unknown_user".tr();
    final quantity = activity.quantityUsed;
    final reason = activity.reason;

    final isLargeDispatch = quantity > 100;
    final statusColor = isLargeDispatch
        ? context.cs.tertiary
        : context.cs.primary;

    return MainTile(
      child: Column(
        spacing: 12,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      plantName,
                      style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        _buildStatusChip(
                          label: "${"quantity".tr()}: $quantity",
                          color: statusColor.withOpacity(0.1),
                          textColor: statusColor,
                        ),
                        _buildStatusChip(
                          label: reason,
                          color: context.cs.secondaryContainer,
                          textColor: context.cs.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildQuantityIndicator(quantity),
            ],
          ),
          const Divider(height: 0),
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: context.cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${"by".tr()}: $userName",
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                activity.createdAt.formatYYYYMMDD,
                style: context.tt.bodySmall?.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        storageLocation,
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (inventory != null)
                Text(
                  "${"current_inventory".tr()}: ${inventory.currentQuantity}",
                  style: context.tt.bodySmall?.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        color: color,
      ),
      child: Padding(
        padding: AppConstants.paddingH12V4,
        child: Text(
          label,
          style: context.tt.bodySmall?.copyWith(
            color: textColor,
            fontWeight: .w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityIndicator(int quantity) {
    final isLarge = quantity > 100;
    final isMedium = quantity > 50 && quantity <= 100;
    final Color color = isLarge
        ? context.cs.tertiary
        : isMedium
        ? context.cs.secondary
        : context.cs.primary;

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: .circle,
        color: color.withOpacity(0.1),
        border: .all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              quantity.toString(),
              style: context.tt.labelSmall?.copyWith(
                color: color,
                fontWeight: .bold,
                fontSize: 10,
              ),
            ),
            Text(
              "units".tr(),
              style: context.tt.labelSmall?.copyWith(
                color: color.withOpacity(0.7),
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
