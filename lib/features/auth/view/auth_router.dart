import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
import 'package:green_mind/global/di/di.dart';

@RoutePage(name: 'AuthRouter')
class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<AuthCubit>(),
      child: const AutoRouter(),
    );
  }
}

