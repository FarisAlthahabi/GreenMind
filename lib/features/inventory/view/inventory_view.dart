// inventory_view.dart
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/inventory/cubit/inventory_cubit.dart';
import 'package:green_mind/features/inventory/model/inventory_model/inventory_model.dart';
import 'package:green_mind/features/inventory/view/widgets/dispatch_inventory_view.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/locale_x.dart';
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
class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<InventoryCubit>()..getInventories(reset: true),
      child: const InventoryPage(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final InventoryCubit inventoryCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchInventories(isRefresh: true);
  }

  void onDispatch(InventoryModel inventory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DispatchInventoryView(
        inventory: inventory,
        inventoryCubit: inventoryCubit,
        onSuccess: () {
          fetchInventories(isRefresh: true);
        },
      ),
    );
  }

  void fetchInventories({bool isRefresh = false}) =>
      inventoryCubit.getInventories(reset: isRefresh);

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      appBar: const MainAppBar(title: "inventory"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_inventory".tr(),
              prefixIcon: const Icon(Icons.search),
              onChanged: inventoryCubit.setSearchQuery,
            ),
            Expanded(
              child: BlocBuilder<InventoryCubit, GeneralInventoryState>(
                buildWhen: (_, current) => current is InventoriesState,
                builder: (context, state) {
                  if (state is InventoriesLoading &&
                      inventoryCubit.inventories.isEmpty) {
                    return const Align(child: LoadingIndicator());
                  } else if (state is InventoriesSuccess) {
                    final inventories = state.inventories;
                    final hasReachedMax = state.hasReachedMax;
                    final currentPage = state.currentPage;

                    return NotificationListener<ScrollUpdateNotification>(
                      onNotification: (scrollInfo) {
                        final maxScroll = scrollInfo.metrics.maxScrollExtent;
                        final currentScroll = scrollInfo.metrics.pixels;

                        if (maxScroll > 0 &&
                            currentScroll >= maxScroll - 200 &&
                            !inventoryCubit.isLoadingMore &&
                            !hasReachedMax) {
                          inventoryCubit.loadMore();
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async =>
                            fetchInventories(isRefresh: true),
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
                                ...inventories.map(
                                  (inventory) =>
                                      _buildInventoryTile(inventory, locale),
                                ),
                                if (!hasReachedMax &&
                                    inventories.isNotEmpty) ...[
                                  const Padding(
                                    padding: AppConstants.paddingV8,
                                    child: LoadingIndicator(size: 30),
                                  ),
                                ] else if (hasReachedMax &&
                                    inventories.isNotEmpty &&
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
                  } else if (state is InventoriesEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      isRefresh: true,
                      onTryAgainTap: () => fetchInventories(isRefresh: true),
                    );
                  } else if (state is InventoriesFail) {
                    return MainErrorWidget(
                      error: state.error,
                      onTryAgainTap: () => fetchInventories(isRefresh: true),
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

  Widget _buildInventoryTile(InventoryModel inventory, Locale locale) {
    final plant = inventory.plant;
    final crop = plant?.crop;
    final cropName = locale.isAr ? crop?.nameAr : crop?.nameEn;
    final plantName = plant?.name ?? "unknown_plant".tr();

    final isLowStock =
        inventory.currentQuantity < (inventory.harvestQuantity * 0.2);
    final stockStatusColor = isLowStock
        ? context.cs.error
        : inventory.currentQuantity > 0
        ? context.cs.primary
        : context.cs.tertiary;

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
                  spacing: 5,
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      plantName,
                      style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                    ),
                    if (cropName != null)
                      Text(
                        "${"crop".tr()}: $cropName",
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (inventory.currentQuantity > 0)
                _buildIconBtn(
                  Icons.inventory_2_outlined,
                  context.cs.secondaryContainer,
                  context.cs.secondary,
                  () => onDispatch(inventory),
                ),
              _buildStockIndicator(inventory),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: _buildStatusChip(
                  label:
                      "${"harvest_quantity".tr()}: ${inventory.harvestQuantity}",
                  color: context.cs.primaryContainer,
                  textColor: context.cs.primary,
                ),
              ),
              Expanded(
                child: _buildStatusChip(
                  label:
                      "${"current_quantity".tr()}: ${inventory.currentQuantity}",
                  color: stockStatusColor.withOpacity(0.1),
                  textColor: stockStatusColor,
                ),
              ),
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
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        inventory.storageLocation,
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${"created_at".tr()}: ${inventory.createdAt.formatYYYYMMDD}",
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
          textAlign: .center,
        ),
      ),
    );
  }

  Widget _buildStockIndicator(InventoryModel inventory) {
    final percentage = inventory.harvestQuantity > 0
        ? (inventory.currentQuantity / inventory.harvestQuantity * 100)
        : 0.0;

    Color getIndicatorColor() {
      if (percentage <= 20) return context.cs.error;
      if (percentage <= 50) return context.cs.tertiary;
      return context.cs.primary;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: .circle,
        color: getIndicatorColor().withOpacity(0.1),
        border: .all(color: getIndicatorColor().withOpacity(0.3), width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: context.tt.labelSmall?.copyWith(
                color: getIndicatorColor(),
                fontWeight: .bold,
              ),
            ),
            Text(
              'stock'.tr(),
              style: context.tt.labelSmall?.copyWith(
                color: getIndicatorColor().withOpacity(0.7),
                fontSize: 8,
              ),
            ),
          ],
        ),
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
