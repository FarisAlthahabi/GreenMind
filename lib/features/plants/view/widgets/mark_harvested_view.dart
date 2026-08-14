// mark_as_harvested_view.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/plants/cubit/plants_cubit.dart';
import 'package:green_mind/features/plants/model/plant_model/plant_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_counter_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class MarkHarvestedView extends StatelessWidget {
  const MarkHarvestedView({
    super.key,
    required this.plant,
    required this.plantsCubit,
    this.onSuccess,
  });

  final PlantModel plant;
  final PlantsCubit plantsCubit;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: plantsCubit,
      child: MarkAsHarvestedWidget(plant: plant, onSuccess: onSuccess),
    );
  }
}

class MarkAsHarvestedWidget extends StatefulWidget {
  const MarkAsHarvestedWidget({super.key, required this.plant, this.onSuccess});

  final PlantModel plant;
  final VoidCallback? onSuccess;

  @override
  State<MarkAsHarvestedWidget> createState() => _MarkAsHarvestedWidgetState();
}

class _MarkAsHarvestedWidgetState extends State<MarkAsHarvestedWidget> {
  late final PlantsCubit plantsCubit = context.read();
  late final TextEditingController notesController;
  DateTime? harvestDate;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
    harvestDate = DateTime.now();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  void onHarvestTap() {
    // You can add notes or harvest date to the cubit if needed
    // For now, just mark as harvested
    plantsCubit.markAsHarvested(widget.plant.id);
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Text(
              "mark_as_harvested".tr(),
              style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
            ),
          ),
          _buildCloseIcon(),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16,
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            MainCounterWidget(
              title: "${"harvest_quantity".tr()} Kg",
              hint: "harvest_quantity",
              onChanged: plantsCubit.setHarvestQuantity,
            ),
            MainTextField(
              title: "storage_location".tr(),
              hintText: "storage_location",
              onChanged: plantsCubit.setStorageLocation,
            ),
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
                    buildWhen: (_, current) => current is MarkHarvestedState,
                    listener: (context, state) {
                      if (state is MarkHarvestedSuccess) {
                        widget.onSuccess?.call();
                        onCancelTap(context);
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is MarkHarvestedFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return MainActionButton(
                        padding: AppConstants.padding16,
                        fontWeight: .bold,
                        onPressed: () => onHarvestTap(),
                        text: "save".tr(),
                        isLoading: state is MarkHarvestedLoading,
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
      child: Icon(Icons.close, size: 20, color: context.cs.onSurfaceVariant),
    );
  }
}
