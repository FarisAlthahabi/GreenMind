// diagnoses_view.dart
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
import 'package:green_mind/features/diagnosing_diseases/view/widgets/diagnoses_filter_widget.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/users/cubit/users_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/extensions/locale_x.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_dialogs.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';
import 'package:readmore/readmore.dart';

@RoutePage()
class DiagnosesView extends StatelessWidget {
  const DiagnosesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              get<DiagnosingDiseasesCubit>()..getDiagnoses(reset: true),
        ),
        BlocProvider(create: (context) => get<UsersCubit>()),
        BlocProvider(create: (context) => get<PlantsCubit>()),
      ],
      child: const DiagnosesPage(),
    );
  }
}

class DiagnosesPage extends StatefulWidget {
  const DiagnosesPage({super.key});

  @override
  State<DiagnosesPage> createState() => _DiagnosesPageState();
}

class _DiagnosesPageState extends State<DiagnosesPage> {
  late final DiagnosingDiseasesCubit diagnosingCubit = context.read();
  late final UsersCubit usersCubit = context.read();
  late final PlantsCubit plantsCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchDiagnoses(isRefresh: true);
    usersCubit.getUsers();
    plantsCubit.getPlants(reset: true, perPage: 10000000);
  }

  void fetchDiagnoses({bool isRefresh = false}) =>
      diagnosingCubit.getDiagnoses(reset: isRefresh);

  void onFilterTap() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: diagnosingCubit),
            BlocProvider.value(value: usersCubit),
            BlocProvider.value(value: plantsCubit),
          ],
          child: const DiagnosesFilterWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      appBar: const MainAppBar(title: "diagnoses"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
          children: [
            MainTextField(
              hintText: "search_for_diagnosis".tr(),
              prefixIcon: const Icon(Icons.search),
              onChanged: diagnosingCubit.setSearchQuery,
            ),
            Expanded(
              child:
                  BlocBuilder<
                    DiagnosingDiseasesCubit,
                    GeneralDiagnosingDiseasesState
                  >(
                    buildWhen: (_, current) =>
                        current is DiagnosesDiseasesState,
                    builder: (context, state) {
                      if (state is DiagnosesDiseasesLoading) {
                        return const Align(child: LoadingIndicator());
                      } else if (state is DiagnosesDiseasesSuccess) {
                        final diagnoses = state.diagnosesDiseases;
                        final hasReachedMax = state.hasReachedMax;
                        final currentPage = state.currentPage;
                        return NotificationListener<ScrollUpdateNotification>(
                          onNotification: (scrollInfo) {
                            final maxScroll =
                                scrollInfo.metrics.maxScrollExtent;
                            final currentScroll = scrollInfo.metrics.pixels;

                            if (maxScroll > 0 &&
                                currentScroll >= maxScroll - 200 &&
                                !diagnosingCubit.isLoadingMore &&
                                !hasReachedMax) {
                              diagnosingCubit.getDiagnoses();
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async =>
                                fetchDiagnoses(isRefresh: true),
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
                                        ...diagnoses.map(
                                          (diagnose) => _buildDiagnoseTile(
                                            diagnose,
                                            locale,
                                          ),
                                        ),
                                        if (!hasReachedMax) ...[
                                          const Padding(
                                            padding: AppConstants.paddingV8,
                                            child: LoadingIndicator(size: 30),
                                          ),
                                        ] else if (diagnoses.isNotEmpty &&
                                            currentPage != 1) ...[
                                          MainErrorWidget(
                                            isRefresh: true,
                                            error: 'no_more_data'.tr(),
                                          ),
                                        ],
                                        const SizedBox(height: 35),
                                      ],
                                    ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is DiagnosesDiseasesEmpty) {
                        return MainErrorWidget(
                          error: state.message,
                          isRefresh: true,
                          onTryAgainTap: () => fetchDiagnoses(isRefresh: true),
                        );
                      } else if (state is DiagnosesDiseasesFail) {
                        return MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: () => fetchDiagnoses(isRefresh: true),
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
      floatingActionButton: MainFab(
        icon: Icons.filter_alt_outlined,
        onTap: onFilterTap,
      ),
    );
  }

  Widget _buildDiagnoseTile(DiagnoseModel diagnose, Locale locale) {
    final diseaseName = locale.isAr ? diagnose.nameAr : diagnose.nameEn;
    final technicalName = diagnose.nameTechnical;
    final plantName = diagnose.plant?.name ?? "unknown_plant".tr();
    final confidence = diagnose.confidencePercentage;
    final isHealthy = (double.tryParse(confidence) ?? 0) > 50;
    final statusColor = isHealthy ? context.cs.primary : context.cs.error;

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
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(
                      diseaseName,
                      style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                    ),
                    if (technicalName.isNotEmpty) ...[
                      Text(
                        technicalName,
                        style: context.tt.bodyMedium?.copyWith(
                          color: context.cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                    Row(
                      spacing: 8,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: AppConstants.borderRadius20,
                            color: statusColor.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: AppConstants.paddingH12V4,
                            child: Row(
                              mainAxisSize: .min,
                              children: [
                                Icon(
                                  isHealthy
                                      ? Icons.check_circle_outline
                                      : Icons.warning_amber_outlined,
                                  color: statusColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "$confidence%",
                                  style: context.tt.bodyMedium?.copyWith(
                                    color: statusColor,
                                    fontWeight: .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: AppConstants.borderRadius20,
                            color: context.cs.secondaryContainer,
                          ),
                          child: Padding(
                            padding: AppConstants.paddingH12V4,
                            child: Text(
                              plantName,
                              style: context.tt.bodyMedium?.copyWith(
                                color: context.cs.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Expanded(
                child: Text(
                  "${"created_at".tr()}: ${diagnose.createdAt.formatYYYYMMDD}",
                  style: context.tt.bodySmall?.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (diagnose.treatment.isNotEmpty) ...[
            const Divider(height: 0),
            Row(
              crossAxisAlignment: .start,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 16,
                  color: context.cs.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ReadMoreText(
                    diagnose.treatment,
                    trimMode: .Line,
                    trimLines: 1,
                    trimCollapsedText: "show_more".tr(),
                    trimExpandedText: "show_less".tr(),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     diagnose.treatment,
                //     style: context.tt.bodyMedium?.copyWith(
                //       color: context.cs.primary,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
          if (diagnose.originalImagePath.isNotEmpty ||
              diagnose.gradCamImagePath.isNotEmpty) ...[
            const Divider(height: 0),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (diagnose.originalImagePath.isNotEmpty)
                  _buildImageLabel(
                    "original_image",
                    // diagnose.originalImagePath,
                    "$baseUrl/${diagnose.originalImagePath}",
                  ),
                if (diagnose.gradCamImagePath.isNotEmpty)
                  _buildImageLabel(
                    "grad_cam",
                    //diagnose.gradCamImagePath
                    "$baseUrl/${diagnose.gradCamImagePath}",
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageLabel(String label, String path) {
    return InkWell(
      onTap: () => MainDialogs.showImageFullScreen(context, path),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppConstants.borderRadius10,
          color: context.cs.surfaceContainerHighest,
        ),
        child: Padding(
          padding: AppConstants.paddingH8V4,
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.image_outlined,
                size: 14,
                color: context.cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label.tr(),
                style: context.tt.bodySmall?.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
