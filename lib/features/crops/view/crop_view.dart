import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/crops/cubit/crops_cubit.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/features/crops/view/widgets/update_crop_view.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/locale_x.dart';
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
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

abstract class CropsViewCallBacks {}

@RoutePage()
class CropsView extends StatelessWidget {
  const CropsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<CropsCubit>(),
      child: const CropsPage(),
    );
  }
}

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> implements CropsViewCallBacks {
  late final CropsCubit cropsCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchCrops();
  }

  void onDeleteCrop(CropModel crop) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InsureDeleteWidget(
        item: crop,
        onSuccess: () => cropsCubit.deleteLocalCrop(crop),
      ),
    );
  }

  void onUpdateCrop(CropModel? crop) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateCropView(cropsCubit: cropsCubit, crop: crop),
    );
  }

  void fetchCrops() => cropsCubit.getCrops();

  @override
  Widget build(BuildContext context) {
    final role = Utils.userRole;
    final locale = context.locale;
    return Scaffold(
      appBar: const MainAppBar(title: "crops"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_for_crop",
              prefixIcon: Icon(Icons.search),
              onChanged: cropsCubit.setSearchQuery,
            ),
            Expanded(
              child: BlocBuilder<CropsCubit, GeneralCropsState>(
                buildWhen: (_, current) => current is CropsState,
                builder: (context, state) {
                  if (state is CropsLoading) {
                    return const Align(child: LoadingIndicator());
                  } else if (state is CropsSuccess) {
                    final crops = state.crops;
                    return RefreshIndicator(
                      onRefresh: () async => fetchCrops(),
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
                              ...crops.map(
                                (crop) => _buildCropTile(crop, role, locale),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is CropsEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      isRefresh: true,
                      onTryAgainTap: fetchCrops,
                    );
                  } else if (state is CropsFail) {
                    return MainErrorWidget(
                      error: state.error,
                      onTryAgainTap: fetchCrops,
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
      floatingActionButton: !role.isFarmer
          ? MainFab(onTap: () => onUpdateCrop(null))
          : null,
    );
  }

  Widget _buildCropTile(CropModel crop, UserRoleEnum role, Locale locale) {
    final name = locale.isAr ? crop.nameAr : crop.nameEn;
    return MainTile(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Text(
                name,
                style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
              ),
              if (!role.isFarmer) ...[
                Spacer(),
                _buildIconBtn(
                  Icons.edit,
                  context.cs.secondaryContainer,
                  context.cs.secondary,
                  () => onUpdateCrop(crop),
                ),
                _buildIconBtn(
                  Icons.delete,
                  context.cs.errorContainer,
                  context.cs.error,
                  () => onDeleteCrop(crop),
                ),
              ],
            ],
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "${"irrigation_days_count".tr()}: ${crop.baseIrrigationDays}",
              ),
              Text("${"date".tr()}: ${crop.createdAt?.formatYYYYMMDD}"),
            ],
          ),
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
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppConstants.borderRadius10,
        ),
        child: Padding(
          padding: AppConstants.padding10,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
