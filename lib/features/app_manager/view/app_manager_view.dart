import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/global/di/di.dart';

@RoutePage()
class AppManagerView extends StatelessWidget {
  const AppManagerView({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: user,
      child: BlocProvider(
        create: (context) => get<AppManagerCubit>(),
        child: const AppManagerPage(),
      ),
    );
  }
}

class AppManagerPage extends StatefulWidget {
  const AppManagerPage({super.key});

  @override
  State<AppManagerPage> createState() => _AppManagerPageState();
}

class _AppManagerPageState extends State<AppManagerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {},
      // child: BlocBuilder<LocalizationCubit, LocalizationState>(
      //   builder: (context, state) {
      //     print("object");
      //     return const AutoRouter();
      //   },
      // ),
      child: const AutoRouter(),
    );
  }
}
