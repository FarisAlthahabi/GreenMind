import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_details_model/diagnose_details_model.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_response_model/diagnose_response_model.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/dio/dio_client.dart';
import 'package:green_mind/global/extensions/locale_x.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/app_image_widget.dart';
import 'package:green_mind/global/widgets/choose_image_widget.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';

@RoutePage()
class DiagnosingDiseasesView extends StatelessWidget {
  const DiagnosingDiseasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => get<DiagnosingDiseasesCubit>()),
        BlocProvider(create: (context) => get<PlantsCubit>()),
      ],
      child: const DiagnosingDiseasesPage(),
    );
  }
}

class DiagnosingDiseasesPage extends StatefulWidget {
  const DiagnosingDiseasesPage({super.key});

  @override
  State<DiagnosingDiseasesPage> createState() => _DiagnosingDiseasesPageState();
}

class _DiagnosingDiseasesPageState extends State<DiagnosingDiseasesPage> {
  late final DiagnosingDiseasesCubit diagnosingDiseasesCubit = context.read();
  late final PlantsCubit plantsCubit = context.read();

  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  void fetchPlants() => plantsCubit.getPlants(reset: true, perPage: 10000000);

  void diagnose() {
    diagnosingDiseasesCubit.diagnose();
  }

  void onApplyChanges(int? plantId, int days) {
    plantsCubit.setIrrigarionDays(days);
    plantsCubit.updatePlant(id: plantId);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppConstants.padding16,
        physics: const BouncingScrollPhysics(),
        child: AnimationLimiter(
          child: Column(
            spacing: 20,
            children: AnimationConfiguration.toStaggeredList(
              duration: AppConstants.duration500ms,
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                ?_buildHeaderDescription(),
                _buildUploadImageWithDiagonseBtn(),
                const SizedBox.shrink(),
                _buildResaultView(locale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildHeaderDescription() {
    if (!_isHeaderVisible) return null;
    return Dismissible(
      key: const ValueKey('header'),
      direction: .horizontal,
      onDismissed: (direction) {
        setState(() {
          _isHeaderVisible = false;
        });
      },
      child: Container(
        width: .infinity,
        padding: AppConstants.paddingH16V12,
        decoration: BoxDecoration(
          color: context.cs.errorContainer,
          borderRadius: AppConstants.borderRadius10,
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: context.cs.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'ai_diagnosis_for_consultation'.tr(),
                style: context.tt.bodyLarge?.copyWith(
                  color: context.cs.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadImageWithDiagonseBtn() {
    return Container(
      padding: AppConstants.padding20,
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: .all(color: context.cs.outline, width: 0.5),
      ),
      child: Column(
        spacing: 20,
        children: [
          Text("upload_image".tr(), style: context.tt.titleLarge),
          ChooseImageWidget(onSetImage: diagnosingDiseasesCubit.onSetImage),
          BlocConsumer<DiagnosingDiseasesCubit, GeneralDiagnosingDiseasesState>(
            listener: (context, state) {
              if (state is DiagnosingDiseasesFail) {
                MainSnackBar.showErrorMessage(context, state.error);
              }
            },
            builder: (context, state) {
              return MainActionButton(
                padding: AppConstants.padding20,
                borderRadius: AppConstants.borderRadius20,
                icon: Icon(Icons.search, color: context.cs.onPrimary, size: 20),
                onPressed: diagnose,
                text: "diagonse_disease".tr(),
                isLoading: state is DiagnosingDiseasesLoading,
              );
            },
          ),
          _buildPlantDropDown(),
        ],
      ),
    );
  }

  Widget _buildResaultView(Locale locale) {
    return BlocBuilder<DiagnosingDiseasesCubit, GeneralDiagnosingDiseasesState>(
      builder: (context, state) {
        Widget child;
        if (state is DiagnosingDiseasesLoading) {
          child = const SizedBox.shrink();
        } else if (state is DiagnosingDiseasesSuccess) {
          child = _buildResults(state.diagnoseResponse, locale);
        } else {
          child = _buildPlaceHolderResualts();
        }
        return AnimatedSizeAndFade(child: child);
      },
    );
  }

  Widget _buildPlaceHolderResualts() {
    return Container(
      padding: AppConstants.padding30,
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: .all(color: context.cs.outline, width: 0.5),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: .stretch,
        children: [
          const Icon(Icons.search, size: 50),
          Text(
            "resaults_appear_here".tr(),
            style: context.tt.titleLarge,
            textAlign: .center,
          ),
          const Text(
            "upload_clear_image_and_press_diagnose",
            textAlign: .center,
          ).tr(),
        ],
      ),
    );
  }

  Widget _buildResults(DiagnoseResponseModel diagnoseResponse, Locale locale) {
    final diagnose = diagnoseResponse.diagnosis;
    final details = diagnoseResponse.details;
    final name = locale.isAr ? diagnose.nameAr : diagnose.nameEn;
    final primary = context.cs.primary;
    final percent = (double.tryParse(diagnose.confidencePercentage) ?? 0);

    return Container(
      padding: AppConstants.padding16,
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: .all(color: context.cs.outline, width: 0.5),
      ),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: .start,
          spacing: 15,
          children: AnimationConfiguration.toStaggeredList(
            duration: AppConstants.duration500ms,
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Text("diagnose_result".tr(), style: context.tt.titleLarge),
              Text("${"discovered_disease".tr()}:"),
              Text(
                name,
                style: context.tt.headlineMedium?.copyWith(
                  color: primary,
                  fontWeight: .bold,
                ),
              ),
              Text("(${diagnose.nameTechnical})"),
              Padding(
                padding: AppConstants.paddingH10,
                child: Text("grad_cam_image".tr(), style: context.tt.bodyLarge),
              ),
              AppImageWidget(
                // url: diagnose.gradCamImagePath,
                url: "$baseUrl/${diagnose.gradCamImagePath}",
                fit: .fitWidth,
                borderRadius: AppConstants.borderRadius20,
                border: .all(width: 0.5, color: context.cs.onSurface),
              ),
              Row(
                children: [
                  const Text("confidence_percentage").tr(),
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(color: primary, shape: .circle),
                    child: Icon(Icons.done, color: context.cs.onPrimary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${diagnose.confidencePercentage}%",
                    style: context.tt.bodyLarge,
                  ),
                ],
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percent / 100),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    minHeight: 14,
                    value: value,
                    borderRadius: AppConstants.borderRadius20,
                    valueColor: AlwaysStoppedAnimation(primary),
                    backgroundColor: context.cs.surfaceContainerHigh,
                  );
                },
              ),
              if (percent > 80)
                Container(
                  padding: AppConstants.paddingH12V8,
                  decoration: BoxDecoration(
                    color: context.cs.primaryContainer,
                    borderRadius: AppConstants.borderRadius15,
                  ),
                  child: const Text("high_accuracy").tr(),
                ),
              _buildRecommendedDays(diagnoseResponse),
              _buildTitleDescription(
                "treatment_recommendations",
                diagnose.treatment,
                context.cs.primaryContainer,
              ),
              ?_buildAdditionalInfoTile(details),
              _buildChatBtn(name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleDescription(String title, String description, Color color) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 5,
      children: [
        Text(
          "${title.tr()}:",
          style: context.tt.titleMedium?.copyWith(fontWeight: .bold),
        ),
        Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppConstants.borderRadius10,
                ),
                child: Padding(
                  padding: AppConstants.padding16,
                  child: Text(description),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget? _buildAdditionalInfoTile(DiagnoseDetailsModel? details) {
    if (details == null) return null;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 5,
      children: [
        Text(
          "${"additional_info".tr()}:",
          style: context.tt.titleMedium?.copyWith(fontWeight: .bold),
        ),
        Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.cs.surfaceContainer,
                  borderRadius: AppConstants.borderRadius10,
                ),
                child: Padding(
                  padding: AppConstants.padding16,
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    spacing: 12,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${"syrian_remedy".tr()}: ",
                          children: [
                            TextSpan(
                              text: details.syrianRemedy,
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                        style: context.tt.bodyMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "${"organic_advice".tr()}: ",
                          children: [
                            TextSpan(
                              text: details.organicAdvice,
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                        style: context.tt.bodyMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "${"symptoms".tr()}: ",
                          children: [
                            TextSpan(
                              text: details.symptoms,
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                        style: context.tt.bodyMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "${"seasonal_timing".tr()}: ",
                          children: [
                            TextSpan(
                              text: details.localTiming,
                              style: context.tt.bodyMedium,
                            ),
                          ],
                        ),
                        style: context.tt.bodyMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: .start,
                        spacing: 4,
                        children: [
                          Icon(Icons.source_outlined, size: 20),
                          Text(
                            "${"source".tr()}: ",
                            style: context.tt.bodyMedium?.copyWith(
                              fontWeight: .bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              details.officialSource,
                              style: context.tt.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatBtn(String diseaseNameArabic) {
    return MainActionButton(
      padding: AppConstants.padding16,
      buttonColor: context.cs.surface,
      border: .all(color: context.cs.primary, width: 1.3),
      borderRadius: AppConstants.borderRadius20,
      fontWeight: .bold,
      icon: Icon(Icons.chat, size: 20, color: context.cs.primary),
      textColor: context.cs.primary,
      onPressed: () {
        context.router.navigate(AiChatBotRoute());
        context.read<AiChatBotCubit>().getAiResponse(
          "${"want_know_more_about".tr()} $diseaseNameArabic",
        );
      },
      text: "ask_agricultural_expert_for_more".tr(),
    );
  }

  Widget _buildPlantDropDown() {
    return BlocBuilder<PlantsCubit, GeneralPlantsState>(
      buildWhen: (_, current) => current is PlantsState,
      builder: (context, state) {
        Widget child;
        if (state is PlantsSuccess) {
          child = MainDropDownWidget<PlantModel>(
            prefixIcon: Icons.local_florist_outlined,
            items: state.plants,
            selectedValue: diagnosingDiseasesCubit.plant,
            text: "select_plant_optional".tr(),
            textColor: context.cs.onSurfaceVariant,
            onChanged: diagnosingDiseasesCubit.setPlant,
            allOptionText: "select_plant_optional",
          );
        } else if (state is PlantsFail) {
          child = MainErrorWidget(
            error: state.error,
            onTryAgainTap: () => fetchPlants(),
          );
        } else {
          child = const SizedBox.shrink();
        }
        return AnimatedSizeAndFade(child: child);
      },
    );
  }

  Widget _buildRecommendedDays(DiagnoseResponseModel diagnoseResponse) {
    final diagnose = diagnoseResponse.diagnosis;
    final intervalDays = diagnoseResponse.recommendation.intervalDays;
    final reason = diagnoseResponse.recommendation.reason;
    return BlocConsumer<PlantsCubit, GeneralPlantsState>(
      buildWhen: (_, current) => current is UpdatePlantState,
      listener: (context, state) {
        if (state is UpdatePlantSuccess) {
          MainSnackBar.showSuccessMessage(context, state.message);
        } else if (state is UpdatePlantFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        Widget? btn;
        if (diagnose.plantId != null) {
          if (state is UpdatePlantSuccess) {
            btn = null;
          } else {
            btn = MainActionButton(
              padding: AppConstants.paddingH10V4,
              borderRadius: AppConstants.borderRadius10,
              onPressed: () => onApplyChanges(diagnose.plantId, intervalDays),
              text: "apply_changes".tr(),
              isLoading: state is UpdatePlantLoading,
            );
          }
        }

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 5,
          children: [
            Text(
              "${"recommended_follow_up".tr()}:",
              style: context.tt.titleMedium?.copyWith(fontWeight: .bold),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.cs.secondaryContainer,
                borderRadius: AppConstants.borderRadius10,
              ),
              child: Padding(
                padding: AppConstants.padding16,
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  spacing: 5,
                  children: [
                    Row(
                      crossAxisAlignment: .start,
                      spacing: 10,
                      children: [
                        Text(
                          "$intervalDays ${"days".tr()}",
                          style: context.tt.bodyMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        if (btn != null) ...[
                          const Spacer(),
                          btn,
                        ] else
                          Expanded(child: Text("${"reason".tr()}: $reason")),
                      ],
                    ),
                    if (btn != null)
                      Row(
                        children: [
                          Expanded(child: Text("${"reason".tr()}: $reason")),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
