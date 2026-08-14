import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/profile/cubit/profile_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/extensions/string_x.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_action_button.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';
import 'package:green_mind/global/widgets/main_tile.dart';

abstract class ProfileViewCallBacks {}

@RoutePage()
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<ProfileCubit>(),
      child: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    implements ProfileViewCallBacks {
  late final ProfileCubit profileCubit = context.read();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() => profileCubit.getProfile();

  void _navigateToAuditLogs(int userId) {
    context.pushRoute(AuditLogsRoute(userId: userId));
  }

  void onChangePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      profileCubit.changePassword();
    }
  }

  void onRefreshProfile() => fetchProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "profile"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: BlocBuilder<ProfileCubit, GeneralProfileState>(
          buildWhen: (_, current) => current is ProfileState,
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: LoadingIndicator());
            } else if (state is ProfileSuccess) {
              return RefreshIndicator(
                onRefresh: () async => onRefreshProfile(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: .stretch,
                    children: [
                      // _buildProfileHeader(state.user),
                      _buildProfileInfo(state.user),
                      _buildChangePasswordForm(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileFail) {
              return MainErrorWidget(
                error: state.error,
                onTryAgainTap: fetchProfile,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserModel user) {
    return MainTile(
      child: Column(
        children: [
          _buildInfoTile(
            Icons.person_outline,
            "name".tr(),
            user.name,
            btn: DecoratedBox(
              decoration: BoxDecoration(
                color: context.cs.secondaryContainer,
                borderRadius: AppConstants.borderRadius10,
              ),
              child: Padding(
                padding: AppConstants.padding8,
                child: InkWell(
                  onTap: () => _navigateToAuditLogs(user.id),
                  child: Icon(Icons.history, color: context.cs.secondary),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _buildInfoTile(Icons.alternate_email, "username".tr(), user.username),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.manage_accounts_outlined,
            "role".tr(),
            user.role.displayName,
          ),
          if (user.createdAt != null) ...[
            const Divider(height: 1),
            _buildInfoTile(
              Icons.calendar_today_outlined,
              "member_since".tr(),
              user.createdAt!.formatYYYYMMDD,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    Widget? btn,
  }) {
    return Padding(
      padding: AppConstants.padding12,
      child: Row(
        children: [
          Icon(icon, color: context.cs.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  label,
                  style: context.tt.labelMedium?.copyWith(
                    color: context.cs.onSurface.withAlpha(150),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: context.tt.bodyLarge?.copyWith(fontWeight: .w500),
                ),
              ],
            ),
          ),
          ?btn,
        ],
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return MainTile(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Center(
              child: Text(
                "change_password".tr(),
                style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
              ),
            ),
            const SizedBox(height: 16),
            MainTextField(
              hintText: "current_password".tr(),
              isPassword: true,
              prefixIcon: const Icon(Icons.lock_outline),
              onChanged: profileCubit.setCurrentPassword,
              validator: (value) => Utils.validateInput(
                value,
                .password,
                emptyMessage: "current_password_required",
              ),
            ),
            const SizedBox(height: 12),
            MainTextField(
              hintText: "new_password".tr(),
              isPassword: true,
              prefixIcon: const Icon(Icons.lock_open_outlined),
              onChanged: profileCubit.setNewPassword,
              validator: (value) => Utils.validateInput(
                value,
                .password,
                emptyMessage: "new_password_required",
              ),
            ),
            const SizedBox(height: 24),
            BlocConsumer<ProfileCubit, GeneralProfileState>(
              listener: (context, state) {
                if (state is ChangePasswordSuccess) {
                  MainSnackBar.showSuccessMessage(context, state.message);
                  profileCubit.clearPasswordModel();
                  _formKey.currentState?.reset();
                } else if (state is ChangePasswordFail) {
                  MainSnackBar.showErrorMessage(context, state.error);
                }
              },
              buildWhen: (previous, current) => current is ChangePasswordState,
              builder: (context, state) {
                return MainActionButton(
                  padding: AppConstants.paddingH36V10,
                  borderRadius: AppConstants.borderRadius10,
                  onPressed: onChangePassword,
                  text: "update_password".tr(),
                  isLoading: state is ChangePasswordLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
