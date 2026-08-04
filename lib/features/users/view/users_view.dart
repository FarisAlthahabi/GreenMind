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
import 'package:green_mind/global/utils/utils.dart';
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
    final role = Utils.userRole;
    return Scaffold(
      appBar: const MainAppBar(title: "users"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          spacing: 20,
          crossAxisAlignment: .start,
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
                    return const Align(child: LoadingIndicator());
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
                              ...users.map(
                                (user) => _buildUserTile(user, role),
                              ),
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

  Widget _buildUserTile(UserModel user, UserRoleEnum role) {
    return Container(
      padding: AppConstants.padding16,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: AppConstants.borderRadius20,
        border: .all(width: 0.2, color: context.cs.onSurface),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: context.cs.surfaceContainerLow,
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Column(
                spacing: 2,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    user.name,
                    style: context.tt.titleLarge?.copyWith(fontWeight: .bold),
                  ),
                  Text(
                    "@${user.username}",
                    style: context.tt.bodyMedium?.copyWith(
                      color: context.cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _buildRoleChip(user.role.displayName, user.role),
            ],
          ),
          if (role.isEngineer && !user.role.isEngineer)
            Row(
              mainAxisAlignment: .end,
              spacing: 10,
              children: [
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
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, UserRoleEnum role) {
    return Container(
      padding: AppConstants.paddingH20V10,
      decoration: BoxDecoration(
        color: role.color.withOpacity(0.1),
        borderRadius: AppConstants.borderRadius10,
        border: .all(color: role.color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: context.tt.labelMedium?.copyWith(
          color: role.color,
          fontWeight: .w600,
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
        padding: AppConstants.padding8,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
