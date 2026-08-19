// dispatch_inventory_view.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/inventory/cubit/inventory_cubit.dart';
import 'package:green_mind/features/inventory/model/inventory_model/inventory_model.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_counter_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class DispatchInventoryView extends StatelessWidget {
  const DispatchInventoryView({
    super.key,
    required this.inventory,
    required this.inventoryCubit,
    this.onSuccess,
  });

  final InventoryModel inventory;
  final InventoryCubit inventoryCubit;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: inventoryCubit,
      child: DispatchInventoryWidget(
        inventory: inventory,
        onSuccess: onSuccess,
      ),
    );
  }
}

class DispatchInventoryWidget extends StatefulWidget {
  const DispatchInventoryWidget({
    super.key,
    required this.inventory,
    this.onSuccess,
  });

  final InventoryModel inventory;
  final VoidCallback? onSuccess;

  @override
  State<DispatchInventoryWidget> createState() =>
      _DispatchInventoryWidgetState();
}

class _DispatchInventoryWidgetState extends State<DispatchInventoryWidget> {
  late final InventoryCubit inventoryCubit = context.read();

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  void onDispatchTap() {
    inventoryCubit.dispatchInventory(widget.inventory.id);
  }

  @override
  Widget build(BuildContext context) {
    final inventory = widget.inventory;

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
              "dispatch_inventory".tr(),
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
            const Divider(height: 0),
            MainCounterWidget(
              title: "quantity_to_dispatch".tr(),
              hint: "enter_quantity".tr(),
              maxCount: inventory.currentQuantity,
              onChanged: inventoryCubit.setQuantityUsed,
            ),
            MainTextField(
              title: "reason".tr(),
              hintText: "reason_hint",
              onChanged: inventoryCubit.setReason,
              minLines: 2,
              maxLines: 4,
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
          child: BlocConsumer<InventoryCubit, GeneralInventoryState>(
            buildWhen: (_, current) => current is DispatchInventoryState,
            listener: (context, state) {
              if (state is DispatchInventorySuccess) {
                widget.onSuccess?.call();
                onCancelTap(context);
                MainSnackBar.showSuccessMessage(context, state.message);
              } else if (state is DispatchInventoryFail) {
                MainSnackBar.showErrorMessage(context, state.error);
              }
            },
            builder: (context, state) {
              return MainActionButton(
                padding: AppConstants.padding16,
                fontWeight: .bold,
                onPressed: onDispatchTap,
                text: "save".tr(),
                isLoading: state is DispatchInventoryLoading,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCloseIcon() {
    return InkWell(
      onTap: () => onCancelTap(context),
      child: Icon(Icons.close, size: 25, color: context.cs.onSurfaceVariant),
    );
  }
}
