import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/crops/cubit/crops_cubit.dart';
import 'package:green_mind/features/crops/model/crop_model/crop_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_counter_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class DeleteModel {
  String get apiDeleteUrl;
}

class UpdateCropView extends StatelessWidget {
  const UpdateCropView({
    super.key,
    this.crop,
    this.onSuccess,
    required this.cropsCubit,
  });
  final CropsCubit cropsCubit;

  final CropModel? crop;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cropsCubit,
      child: UpdateCropWidget(crop: crop, onSuccess: onSuccess),
    );
  }
}

class UpdateCropWidget extends StatefulWidget {
  const UpdateCropWidget({super.key, this.crop, this.onSuccess});

  final CropModel? crop;
  final VoidCallback? onSuccess;

  @override
  State<UpdateCropWidget> createState() => _UpdateCropWidgetState();
}

class _UpdateCropWidgetState extends State<UpdateCropWidget> {
  late final CropsCubit cropsCubit = context.read();

  @override
  void initState() {
    super.initState();
    cropsCubit.setModel(widget.crop);
  }

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    cropsCubit.clearModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;
    final title = crop == null ? "add_crop".tr() : "update_crop".tr();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius20,
        side: BorderSide(color: context.cs.outline, width: 0.3),
      ),
      backgroundColor: context.cs.surface,
      contentPadding: AppConstants.padding30,
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [Text(title), _buildCloseIcon()],
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            MainTextField(
              initialText: crop?.nameEn,
              title: "name_en".tr(),
              hintText: "${"example".tr()}: Tomato Crop",
              onChanged: cropsCubit.setNameEn,
            ),
            MainTextField(
              initialText: crop?.nameAr,
              title: "name_ar".tr(),
              hintText: "${"example".tr()}: حقل بطاطا",
              onChanged: cropsCubit.setNameAr,
            ),
            MainCounterWidget(
              initialCount: crop?.baseIrrigationDays,
              title: "irrigation_days".tr(),
              hint: "${"example".tr()}: 1",
              onChanged: cropsCubit.setIrrigarionDays,
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
                    border: Border.all(width: 0.3, color: context.cs.outline),
                    textColor: context.cs.onSurface,
                    fontWeight: .bold,
                    text: "cancel".tr(),
                    onPressed: () => onCancelTap(context),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<CropsCubit, GeneralCropsState>(
                    buildWhen: (_, current) => current is UpdateCropState,
                    listener: (context, state) {
                      if (state is UpdateCropSuccess) {
                        widget.onSuccess?.call();
                        onCancelTap(context);
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is UpdateCropFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      var onTap = () => cropsCubit.updateCrop(id: crop?.id);
                      Widget? child;
                      if (state is UpdateCropLoading) {
                        onTap = () async {};
                        // TODO use color from theme
                        child = LoadingIndicator(
                          isInBtn: true,
                          color: Colors.white,
                        );
                      }
                      return MainActionButton(
                        padding: AppConstants.padding16,
                        textColor: Colors.white,
                        fontWeight: .bold,
                        onPressed: () => onTap(),
                        text: "save".tr(),
                        child: child,
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
      child: Icon(Icons.close, size: 20),
    );
  }
}
