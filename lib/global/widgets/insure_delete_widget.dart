import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';

abstract class DeleteModel {
  String get apiDeleteUrl;
}

class InsureDeleteWidget<T extends DeleteModel> extends StatelessWidget {
  const InsureDeleteWidget({
    super.key,
    required this.item,
    this.onSuccess,
    this.description = "this_item",
  });
  final T item;
  final String description;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<DeleteCubit>(),
      child: InsureDeleteView(
        item: item,
        description: description,
        onSuccess: onSuccess,
      ),
    );
  }
}

class InsureDeleteView<T extends DeleteModel> extends StatefulWidget {
  const InsureDeleteView({
    super.key,
    required this.item,
    this.onSuccess,
    required this.description,
  });

  final T item;
  final String description;
  final VoidCallback? onSuccess;

  @override
  State<InsureDeleteView<T>> createState() => _InsureDeleteViewState<T>();
}

class _InsureDeleteViewState<T extends DeleteModel>
    extends State<InsureDeleteView<T>> {
  late final DeleteCubit deleteCubit = context.read();

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  void onDelete() => deleteCubit.deleteItem(widget.item);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius20,
        side: BorderSide(color: context.cs.outline, width: 0.3),
      ),
      backgroundColor: context.cs.surface,
      contentPadding: AppConstants.padding30,
      title: _buildIcon(),
      content: Column(
        spacing: 20,
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Text(
            "insure_delete".tr(),
            style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
          ),
          Text(
            "${"sure_to_delete".tr()} ${widget.description.tr()} ? ${"can_not_undo".tr()}",
            textAlign: .center,
            style: context.tt.bodyMedium?.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
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
                child: BlocConsumer<DeleteCubit, DeleteState>(
                  listener: (context, state) {
                    if (state is DeleteSuccess) {
                      widget.onSuccess?.call();
                      onCancelTap(context);
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is DeleteFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return MainActionButton(
                      padding: AppConstants.padding16,
                      buttonColor: context.cs.error,
                      // TODO color from theme
                      textColor: Colors.white,
                      fontWeight: .bold,
                      onPressed: () => onDelete(),
                      text: "save".tr(),
                      isLoading: state is DeleteLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.cs.errorContainer,
          borderRadius: AppConstants.borderRadiusCircle,
        ),
        child: Padding(
          padding: AppConstants.padding16,
          child: Icon(Icons.delete, color: context.cs.error, size: 25),
        ),
      ),
    );
  }
}
