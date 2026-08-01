import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/features/users/cubit/users_cubit.dart';
import 'package:green_mind/features/users/view/widgets/update_user_widget.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/models/user_role_enum.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/insure_delete_widget.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';
import 'package:green_mind/global/widgets/main_error_widget.dart';
import 'package:green_mind/global/widgets/main_fab.dart';
import 'package:green_mind/global/widgets/main_text_field.dart';

abstract class UsersViewCallBacks {}

@RoutePage()
class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<UsersCubit>(),
      child: const UsersPage(),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> implements UsersViewCallBacks {
  late final UsersCubit usersCubit = context.read();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void onDeleteUser(UserModel user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InsureDeleteWidget(
        item: user,
        onSuccess: () => usersCubit.deleteLocalUser(user.id),
      ),
    );
  }

  void onUpdateUser(UserModel? user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateUserView(usersCubit: usersCubit, user: user),
    );
  }

  void fetchUsers() => usersCubit.getUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: "users"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainTextField(
              hintText: "search_for_user",
              prefixIcon: Icon(Icons.search),
              onChanged: usersCubit.setSearchQuery,
            ),
            Expanded(
              child: BlocBuilder<UsersCubit, GeneralUsersState>(
                buildWhen: (_, current) => current is UsersState,
                builder: (context, state) {
                  if (state is UsersLoading) {
                    return Align(child: LoadingIndicator());
                  } else if (state is UsersSuccess) {
                    final users = state.users;
                    return RefreshIndicator(
                      onRefresh: () async => fetchUsers(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          spacing: 16,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: AppConstants.duration500ms,
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              ...users.map(_buildUserTile),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is UsersEmpty) {
                    return MainErrorWidget(
                      error: state.message,
                      onTryAgainTap: fetchUsers,
                    );
                  } else if (state is UsersFail) {
                    return MainErrorWidget(
                      error: state.error,
                      isRefresh: true,
                      onTryAgainTap: fetchUsers,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MainFab(onTap: () => onUpdateUser(null)),
    );
  }

  Widget _buildUserTile(UserModel user) {
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: Border.all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: context.tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${user.username}",
                      style: context.tt.bodyMedium?.copyWith(
                        color: context.cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildRoleChip(user.role.displayName, user.role),
              _buildIconBtn(
                Icons.edit,
                context.cs.secondaryContainer,
                context.cs.secondary,
                () => onUpdateUser(user),
              ),
              _buildIconBtn(
                Icons.delete,
                context.cs.errorContainer,
                context.cs.error,
                () => onDeleteUser(user),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "${"created_at".tr()}: ${user.createdAt?.formatYYYYMMDD ?? "-"}",
          //       style: context.tt.bodySmall,
          //     ),
          //     if (user.updatedAt != null)
          //       Text(
          //         "${"updated_at".tr()}: ${user.updatedAt?.formatYYYYMMDD ?? "-"}",
          //         style: context.tt.bodySmall,
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, UserRoleEnum role) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: role.color.withOpacity(0.1),
        borderRadius: AppConstants.borderRadius10,
        border: Border.all(color: role.color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: context.tt.labelSmall?.copyWith(
          color: role.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildIconBtn(
    IconData icon,
    Color bgColor,
    Color color,
    void Function() onTap,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppConstants.borderRadius10,
      ),
      child: Padding(
        padding: AppConstants.padding10,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
