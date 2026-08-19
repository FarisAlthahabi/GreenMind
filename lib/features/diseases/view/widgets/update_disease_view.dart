import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/diseases/cubit/diseases_cubit.dart';
import 'package:green_mind/features/diseases/model/disease_model/disease_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class UpdateDiseaseView extends StatelessWidget {
  const UpdateDiseaseView({
    super.key,
    this.disease,
    this.onSuccess,
    required this.diseasesCubit,
  });
  final DiseasesCubit diseasesCubit;

  final DiseaseModel? disease;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: diseasesCubit,
      child: UpdateDiseaseWidget(disease: disease, onSuccess: onSuccess),
    );
  }
}

class UpdateDiseaseWidget extends StatefulWidget {
  const UpdateDiseaseWidget({super.key, this.disease, this.onSuccess});

  final DiseaseModel? disease;
  final VoidCallback? onSuccess;

  @override
  State<UpdateDiseaseWidget> createState() => _UpdateDiseaseWidgetState();
}

class _UpdateDiseaseWidgetState extends State<UpdateDiseaseWidget> {
  late final DiseasesCubit diseasesCubit = context.read();

  @override
  void initState() {
    super.initState();
    diseasesCubit.setModel(widget.disease);
  }

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    diseasesCubit.clearModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disease = widget.disease;
    final title = disease == null ? "add_disease".tr() : "update_disease".tr();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius20,
        side: BorderSide(color: context.cs.outline, width: 0.3),
      ),
      backgroundColor: context.cs.surface,
      contentPadding: AppConstants.padding30,
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
          ),
          _buildCloseIcon(),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            MainTextField(
              initialText: disease?.technicalName,
              title: "technical_name".tr(),
              hintText: "${"example".tr()}: Tomato_Late_blight",
              onChanged: diseasesCubit.setTechnicalName,
            ),
            MainTextField(
              initialText: disease?.enName,
              title: "name_en".tr(),
              hintText: "${"example".tr()}: Tomato Late Blight",
              onChanged: diseasesCubit.setEnName,
            ),
            MainTextField(
              initialText: disease?.arName,
              title: "name_ar".tr(),
              hintText: "${"example".tr()}: لفحة البندورة المتأخرة",
              onChanged: diseasesCubit.setArName,
            ),
            const SizedBox.shrink(),
            Row(
              spacing: 10,
              mainAxisAlignment: .end,
              children: [
                Expanded(
                  child: MainActionButton(
                    padding: AppConstants.padding16,
                    buttonColor: Colors.transparent,
                    border: .all(width: 0.3, color: context.cs.outline),
                    textColor: context.cs.onSurface,
                    fontWeight: .bold,
                    text: "cancel".tr(),
                    onPressed: () => onCancelTap(context),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<DiseasesCubit, GeneralDiseasesState>(
                    buildWhen: (_, current) => current is UpdateDiseaseState,
                    listener: (context, state) {
                      if (state is UpdateDiseaseSuccess) {
                        widget.onSuccess?.call();
                        onCancelTap(context);
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is UpdateDiseaseFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return MainActionButton(
                        padding: AppConstants.padding16,
                        fontWeight: .bold,
                        onPressed: () =>
                            diseasesCubit.updateDisease(id: disease?.id),
                        text: "save".tr(),
                        isLoading: state is UpdateDiseaseLoading,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return InkWell(
      onTap: () => onCancelTap(context),
      child: const Icon(Icons.close, size: 25),
    );
  }
}
