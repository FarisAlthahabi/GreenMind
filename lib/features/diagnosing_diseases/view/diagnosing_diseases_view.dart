import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
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
        child: Column(
          spacing: 20,
          children: [
            _buildHeaderDescription(),
            _buildUploadImageWithDiagonseBtn(),
            const SizedBox.shrink(),
            _buildResaultView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return Container(
      width: double.infinity,
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
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(color: context.cs.primary, width: 0.5),
      ),
      child: Column(
        spacing: 20,
        children: [
          Text("upload_image".tr(), style: context.tt.titleLarge),
          ChooseImageWidget(),
          // ChooseImageWidget(onSetImage: diagnosingDiseasesCubit.onSetImage),
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
        if (state is DiagnosingDiseasesLoading) {
          return const SizedBox.shrink();
        } else if (state is DiagnosingDiseasesSuccess) {
          return _buildResults();
        }
        return _buildPlaceHolderResualts();
      },
    );
  }

  Widget _buildPlaceHolderResualts() {
    return Container(
      padding: AppConstants.padding30,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(color: context.cs.primary, width: 0.5),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.search, size: 50),
          Text(
            "resaults_appear_here".tr(),
            style: context.tt.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            "upload_clear_image_and_press_diagnose".tr(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final trustPercent = 92.5;
    return Container(
      padding: AppConstants.padding16,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(color: context.cs.primary, width: 0.5),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("نتيجة المرض", style: context.tt.titleLarge),
          Text("المرض المكتشف :"),
          Text(
            "لفحة متأخرة",
            style: context.tt.headlineMedium?.copyWith(
              color: context.cs.primary,
            ),
          ),
          Text("(Late Blight)"),
          Row(
            children: [
              Text("نسبة الثقة"),
              Spacer(),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.done, color: context.cs.onPrimary),
              ),
              SizedBox(width: 10),
              Text(
                "${trustPercent.toStringAsFixed(1)}%",
                style: context.tt.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
