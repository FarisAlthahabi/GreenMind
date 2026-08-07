import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/features/diagnosing_diseases/model/diagnose_model/diagnose_model.dart';
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
          child = _buildResults(state.diagnose);
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

  Widget _buildResults(DiagnoseModel diagnose) {
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
              // Container(
              //   padding: AppConstants.paddingH16V12,
              //   decoration: BoxDecoration(
              //     color: context.cs.surfaceContainer,
              //     borderRadius: AppConstants.borderRadius10,
              //   ),
              //   child: Row(
              //     crossAxisAlignment: .start,
              //     children: [
              //       const Icon(Icons.info_outline, size: 20),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: Text(
              //           "النموذج ركز على منطقة البقع البنية في الجزء العلوي الأيسر من الورقة",
              //           style: context.tt.bodyMedium,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Text(
                "${"treatment_recommendations".tr()}:",
                style: context.tt.titleMedium?.copyWith(fontWeight: .bold),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.cs.primaryContainer,
                  borderRadius: AppConstants.borderRadius10,
                ),
                child: Padding(
                  padding: AppConstants.padding16,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: .start,
                    children: [
                      _buildRecommendationItem(context, diagnose.treatment),
                      // _buildRecommendationItem(
                      //   context,
                      //   "1.  إزالة الأوراق المصابة فوراً والتخلص منها",
                      // ),
                      // _buildRecommendationItem(
                      //   context,
                      //   "2.  رش النباتات بمبيد قطري يحتوي على مانكوزيب",
                      // ),
                      // _buildRecommendationItem(
                      //   context,
                      //   "3.  تحسين التهوية بين النباتات",
                      // ),
                      // _buildRecommendationItem(
                      //   context,
                      //   "4.  تجنب الري العلوي للحد من انتشار المرض",
                      // ),
                      // _buildRecommendationItem(
                      //   context,
                      //   "5.  مراقبة النباتات يومياً للكشف المبكر عن الإصابات الجديدة",
                      // ),
                    ],
                  ),
                ),
              ),
              MainActionButton(
                padding: AppConstants.padding16,
                buttonColor: context.cs.surface,
                border: .all(color: primary, width: 1.5),
                borderRadius: AppConstants.borderRadius20,
                fontWeight: .bold,
                icon: Icon(Icons.chat, size: 20, color: primary),
                textColor: primary,
                onPressed: () {
                  context.router.navigate(AiChatBotRoute());
                  context.read<AiChatBotCubit>().getAiResponse(
                    "${"want_know_more_about".tr()} ${diagnose.diseaseNameArabic}",
                  );
                },
                text: "ask_agricultural_expert_for_more".tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: .start,
      children: [Expanded(child: Text(text, style: context.tt.bodyMedium))],
    );
  }
}
