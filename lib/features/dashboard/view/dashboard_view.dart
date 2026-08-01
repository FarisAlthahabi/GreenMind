import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/widgets/main_app_bar.dart';
import 'package:green_mind/global/widgets/main_drawer.dart';

class PageTitleIconModel {
  final PageRouteInfo page;
  final String title;
  final IconData icon;

  PageTitleIconModel(this.page, this.title, this.icon);
}

@RoutePage()
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<AiChatBotCubit>(),
      child: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final UserModel user = context.read();

  late final navItems = [
    PageTitleIconModel(AiChatBotRoute(), "ai_chat_bot".tr(), Icons.chat),
    PageTitleIconModel(
      DiagnosingDiseasesRoute(),
      "diagnosing_diseases".tr(),
      Icons.medical_services,
    ),
  ];

  late final List<PageRouteInfo> routes = navItems.map((e) => e.page).toList();

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      drawer: const MainDrawer(),
      appBarBuilder: (context, tabsRouter) => const MainAppBar(),
      routes: routes,
      resizeToAvoidBottomInset: true,
      bottomNavigationBuilder: (context, tabsRouter) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppConstants.borderRadiusT25,
            color: context.cs.surface,
            boxShadow: [
              BoxShadow(
                color: context.cs.onTertiaryContainer.withAlpha(60),
                offset: const Offset(0, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: AppConstants.paddingV8,
            child: ClipRRect(
              borderRadius: AppConstants.borderRadiusT25,
              child: BottomNavigationBar(
                backgroundColor: context.cs.surface,
                selectedItemColor: context.cs.primary,
                unselectedItemColor: context.cs.outlineVariant,
                // type: BottomNavigationBarType.shifting,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                items: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  final isSelected = tabsRouter.activeIndex == index;
                  return BottomNavigationBarItem(
                    icon: _getBottomBarIcon(item, isSelected: isSelected),
                    label: item.title,
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getBottomBarIcon(
    PageTitleIconModel item, {
    required bool isSelected,
  }) {
    // final color = isSelected ? context.cs.primary : AppColors.grey;
    return Icon(item.icon);
  }
}
