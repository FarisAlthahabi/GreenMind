import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_response_model/diagnose_response_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/app_image_widget.dart';
import 'package:green_mind/global/widgets/choose_image_widget.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';

@RoutePage()
class DiagnosingDiseasesView extends StatelessWidget {
  const DiagnosingDiseasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<DiagnosingDiseasesCubit>(),
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

  void diagnose() {
    diagnosingDiseasesCubit.diagnose();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeaderDescription(),
                _buildUploadImageWithDiagonseBtn(),
                const SizedBox.shrink(),
                _buildResaultView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return Container(
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
        ],
      ),
    );
  }

  Widget _buildResaultView() {
    return BlocBuilder<DiagnosingDiseasesCubit, GeneralDiagnosingDiseasesState>(
      builder: (context, state) {
        Widget child;
        if (state is DiagnosingDiseasesLoading) {
          child = const SizedBox.shrink();
        } else if (state is DiagnosingDiseasesSuccess) {
          child = _buildResults(state.diagnoseResponse);
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

  Widget _buildResults(DiagnoseResponseModel diagnoseResponse) {
    final diagnose = diagnoseResponse.diagnosis;
    final details = diagnoseResponse.details;
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
                diagnose.diseaseNameTechnical,
                style: context.tt.headlineMedium?.copyWith(color: primary),
              ),
              Text(diagnose.diseaseNameArabic),
              if (details?.localName.isNotEmpty == true) ...[
                Text(
                  "${"local_name".tr()}: ${details?.localName ?? "---"}",
                  style: context.tt.bodyMedium,
                ),
              ],
              Padding(
                padding: AppConstants.paddingH10,
                child: const Text("grad_cam_image").tr(),
              ),
              AppImageWidget(
                url: diagnose.gradCamImagePath,
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
              Container(
                padding: AppConstants.padding16,
                decoration: BoxDecoration(
                  color: context.cs.secondaryContainer,
                  borderRadius: AppConstants.borderRadius10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: context.cs.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${"recommended_follow_up".tr()}: ${diagnoseResponse.recommendedIntervalDays} ${"days".tr()}",
                      style: context.tt.bodyMedium,
                    ),
                  ],
                ),
              ),
              _buildTitleDescription(
                "treatment_recommendations",
                diagnose.treatment,
                context.cs.primaryContainer,
              ),
              if (details?.syrianRemedy.isNotEmpty == true) ...[
                _buildTitleDescription(
                  "syrian_remedy",
                  details?.syrianRemedy ?? "---",
                  context.cs.secondaryContainer,
                ),
              ],
              if (details?.organicAdvice.isNotEmpty == true)
                _buildTitleDescription(
                  "organic_advice",
                  details?.organicAdvice ?? "---",
                  context.cs.tertiaryContainer,
                ),
              if (details?.symptoms.isNotEmpty == true)
                _buildTitleDescription(
                  "symptoms",
                  details?.symptoms ?? "---",
                  context.cs.errorContainer.withOpacity(0.3),
                ),
              if (details?.localTiming.isNotEmpty == true)
                _buildIconTitleDescription(
                  Icons.access_time,
                  "seasonal_timing",
                  details?.localTiming ?? "---",
                ),
              if (details?.officialSource.isNotEmpty == true)
                _buildIconTitleDescription(
                  Icons.source,
                  "source",
                  details?.officialSource ?? "---",
                  fontStyle: .italic,
                ),
              _buildChatBtn(diagnose.diseaseNameArabic),
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

  Widget _buildIconTitleDescription(
    IconData icon,
    String title,
    String description, {
    FontStyle fontStyle = .normal,
  }) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, size: 18, color: context.cs.primary),
        Text(
          "${title.tr()}: $description",
          style: context.tt.bodyMedium?.copyWith(fontStyle: fontStyle),
        ),
      ],
    );
  }

  Widget _buildChatBtn(String diseaseNameArabic) {
    return MainActionButton(
      padding: AppConstants.padding16,
      buttonColor: context.cs.surface,
      border: .all(color: context.cs.primary, width: 1.5),
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
}
