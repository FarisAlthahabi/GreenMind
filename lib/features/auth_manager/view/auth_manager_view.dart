import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart';
import 'package:green_mind/global/router/app_router.gr.dart';

@RoutePage()
class AuthManagerView extends StatefulWidget {
  const AuthManagerView({super.key});

  @override
  State<AuthManagerView> createState() => _AuthManagerViewState();
}

class _AuthManagerViewState extends State<AuthManagerView> {
  @override
  void initState() {
    super.initState();
    context.read<AuthManagerBloc>().add(IsAuthenticatedOrFirstTime());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthManagerBloc, GeneralAuthManagerState>(
      builder: (context, state) {
        return AutoRouter.declarative(
          routes: (context) {
            return [
              if (state is UnauthenticatedState) const AuthRouter(),
              if (state is AuthenticatedState)
                AppManagerRoute(user: state.user),
            ];
          },
        );
      },
    );
  }
}
