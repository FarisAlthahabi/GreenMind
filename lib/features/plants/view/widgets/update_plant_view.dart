import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/crops/cubit/crops_cubit.dart';
import 'package:green_mind/features/diseases/cubit/diseases_cubit.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/date_x.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_counter_widget.dart';
import 'package:green_mind/global/widgets/main_date_picker.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class UpdatePlantView extends StatelessWidget {
  const UpdatePlantView({
    super.key,
    this.plant,
    this.onSuccess,
    required this.plantsCubit,
  });
  final PlantsCubit plantsCubit;

  final PlantModel? plant;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: plantsCubit),
        BlocProvider(create: (context) => get<CropsCubit>()),
        BlocProvider(create: (context) => get<DiseasesCubit>()),
      ],
      child: UpdatePlantWidget(plant: plant, onSuccess: onSuccess),
    );
  }
}

class UpdatePlantWidget extends StatefulWidget {
  const UpdatePlantWidget({super.key, this.plant, this.onSuccess});

  final PlantModel? plant;
  final VoidCallback? onSuccess;

  @override
  State<UpdatePlantWidget> createState() => _UpdatePlantWidgetState();
}

class _UpdatePlantWidgetState extends State<UpdatePlantWidget> {
  late final PlantsCubit plantsCubit = context.read();
  late final CropsCubit cropsCubit = context.read();
  late final DiseasesCubit diseasesCubit = context.read();

  @override
  void initState() {
    super.initState();
    cropsCubit.getCrops();
    diseasesCubit.getDiseases();
    plantsCubit.setModel(widget.plant);
  }

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    plantsCubit.clearModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;
    final title = plant == null ? "add_plant".tr() : "update_plant".tr();
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
              initialText: plant?.name,
              title: "name".tr(),
              hintText: "${"example".tr()}: Tomato",
              onChanged: plantsCubit.setName,
            ),
            _buildCropsDropDown(),
            MainDatePicker(
              title: "planting_date".tr(),
              lastDate: DateTime.now(),
              initialDate: plant?.plantingDate,
              onDateSelected: (date) =>
                  plantsCubit.setPlantingDate(date?.formatYYYYMMDD),
            ),
            if (plant != null)
              MainDatePicker(
                title: "harvest_date".tr(),
                initialDate: plant.harvestDate,
                onDateSelected: (date) =>
                    plantsCubit.setHarvestDate(date?.formatYYYYMMDD),
              ),
            MainCounterWidget(
              initialCount: plant?.quantity,
              title: "quantity".tr(),
              hint: "plants_count",
              onChanged: plantsCubit.setQuantity,
            ),
            if (plant != null) _buildDiseasesDropDown(),
            // MainTextField(
            //   initialText: plant.healthStatus,
            //   title: "health_status".tr(),
            //   hintText: "healthy".tr(),
            //   onChanged: plantsCubit.setHealthStatus,
            // ),
            MainTextField(
              initialText: plant?.notes,
              title: "notes".tr(),
              hintText: "additional_notes".tr(),
              onChanged: plantsCubit.setNotes,
              minLines: 3,
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
                  child: BlocConsumer<PlantsCubit, GeneralPlantsState>(
                    buildWhen: (_, current) => current is UpdatePlantState,
                    listener: (context, state) {
                      if (state is UpdatePlantSuccess) {
                        widget.onSuccess?.call();
                        onCancelTap(context);
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is UpdatePlantFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      var onTap = () => plantsCubit.updatePlant(id: plant?.id);
                      Widget? child;
                      if (state is UpdatePlantLoading) {
                        onTap = () async {};
                        // TODO use color from theme
                        child = const LoadingIndicator(
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

  Widget _buildCropsDropDown() {
    return BlocBuilder<CropsCubit, GeneralCropsState>(
      buildWhen: (_, current) => current is CropsState,
      builder: (context, state) {
        if (state is CropsLoading) {
          return const LoadingIndicator();
        } else if (state is CropsSuccess) {
          final selectedValue = state.crops.firstWhereOrNull(
            (crop) => crop.id == widget.plant?.cropId,
          );
          return MainDropDownWidget(
            label: "crop_type".tr(),
            selectedValue: selectedValue,
            items: state.crops,
            text: "select_crop_type".tr(),
            onChanged: plantsCubit.setCrop,
          );
        } else if (state is CropsEmpty) {
          return MainErrorWidget(
            error: state.message,
            isRefresh: true,
            onTryAgainTap: cropsCubit.getCrops,
          );
        } else if (state is CropsFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: cropsCubit.getCrops,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDiseasesDropDown() {
    return BlocBuilder<DiseasesCubit, GeneralDiseasesState>(
      buildWhen: (_, current) => current is DiseasesState,
      builder: (context, state) {
        if (state is DiseasesLoading) {
          return const LoadingIndicator();
        } else if (state is DiseasesSuccess) {
          return MainDropDownWidget(
            label: "health_status".tr(),
            items: state.diseases,
            selectedValue: widget.plant?.disease,
            text: "select_disease_status".tr(),
            onChanged: plantsCubit.setDiseaseId,
          );
        } else if (state is DiseasesEmpty) {
          return MainErrorWidget(
            error: state.message,
            onTryAgainTap: diseasesCubit.getDiseases,
            isRefresh: true,
          );
        } else if (state is DiseasesFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: diseasesCubit.getDiseases,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCloseIcon() {
    return InkWell(
      onTap: () => onCancelTap(context),
      child: Icon(Icons.close, size: 20),
    );
  }
}
