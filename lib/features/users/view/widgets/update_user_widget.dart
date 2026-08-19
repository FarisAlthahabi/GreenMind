import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/users/cubit/users_cubit.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_drop_down_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

class UpdateUserView extends StatelessWidget {
  const UpdateUserView({super.key, this.user, required this.usersCubit});
  final UsersCubit usersCubit;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: usersCubit,
      child: UpdateUserWidget(user: user),
    );
  }
}

class UpdateUserWidget extends StatefulWidget {
  const UpdateUserWidget({super.key, this.user});

  final UserModel? user;

  @override
  State<UpdateUserWidget> createState() => _UpdateUserWidgetState();
}

class _UpdateUserWidgetState extends State<UpdateUserWidget> {
  late final UsersCubit usersCubit = context.read();

  @override
  void initState() {
    super.initState();
    usersCubit.setModel(widget.user);
  }

  void onCancelTap(BuildContext context) => Navigator.pop(context);

  @override
  void dispose() {
    usersCubit.clearModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final title = user == null ? "add_user".tr() : "update_user".tr();
    final isEdit = user != null;
    final selectedValue = UserRoleEnum.values.firstWhereOrNull(
      (role) => role.id == user?.role.id,
    );

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
              initialText: user?.name,
              title: "name".tr(),
              hintText: "${"example".tr()}: John Doe",
              onChanged: usersCubit.setName,
            ),
            MainTextField(
              initialText: user?.username,
              title: "username".tr(),
              hintText: "${"example".tr()}: john_doe",
              onChanged: usersCubit.setUsername,
            ),
            MainTextField(
              title: isEdit ? "new_password_optional".tr() : "password".tr(),
              hintText: isEdit
                  ? "leave_blank_to_keep".tr()
                  : "${"example".tr()}: ********",
              isPassword: true,
              onChanged: usersCubit.setPassword,
            ),
            MainDropDownWidget(
              label: "role".tr(),
              selectedValue: selectedValue,
              items: UserRoleEnum.values
                  .where((role) => !role.isAdmin)
                  .toList(),
              showAllOption: false,
              text: "select_role".tr(),
              onChanged: usersCubit.setRole,
            ),
            // _buildRoleDropdown(),
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
                  child: BlocConsumer<UsersCubit, GeneralUsersState>(
                    buildWhen: (_, current) => current is UpdateUserState,
                    listener: (context, state) {
                      if (state is UpdateUserSuccess) {
                        onCancelTap(context);
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is UpdateUserFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return MainActionButton(
                        padding: AppConstants.padding16,
                        fontWeight: .bold,
                        onPressed: () => usersCubit.updateUser(id: user?.id),
                        text: "save".tr(),
                        isLoading: state is UpdateUserLoading,
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
      child: Icon(Icons.close, size: 25),
    );
  }
}
