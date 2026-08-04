import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' as t;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_mind/features/auth/cubit/auth_cubit.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/localization/supported_locales.dart';
import 'package:green_mind/global/router/app_router.gr.dart';
import 'package:green_mind/global/theme/cubit/theme_cubit.dart';
import 'package:green_mind/global/theme/theme_x.dart';
import 'package:green_mind/global/utils/constants.dart';
import 'package:green_mind/global/utils/utils.dart';
import 'package:green_mind/global/widgets/loading_indicator.dart';
import 'package:green_mind/global/widgets/main_snack_bar.dart';
import 'package:green_mind/global/widgets/restart_app_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class DrawerTabModel {
  final IconData icon;
  final String title;
  final PageRouteInfo route;
  const DrawerTabModel(this.icon, this.title, this.route);
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<AuthCubit>(),
      child: const MainDrawerWidget(),
    );
  }
}

class MainDrawerWidget extends StatefulWidget {
  const MainDrawerWidget({super.key});

  @override
  State<MainDrawerWidget> createState() => _MainDrawerWidgetState();
}

class _MainDrawerWidgetState extends State<MainDrawerWidget> {
  late final UserModel user = context.read();
  late final ThemeCubit themeCubit = context.read();
  // late final LocalizationCubit localizationCubit = context.read();
  late bool isArabic = context.locale == SupportedLocales.arabic;
  late bool isDark = Theme.of(context).brightness == Brightness.dark;

  void onChangeLanguageTap() {
    setState(() {
      isArabic = !isArabic;
    });
    final newLocale = isArabic
        ? SupportedLocales.arabic
        : SupportedLocales.english;
    context.setLocale(newLocale);
    final prefs = get<SharedPreferences>();
    prefs.setString('locale', newLocale.languageCode);
    // localizationCubit.emitLanguageChanged();
    RestartAppWidget.restartApp(context);
  }

  void onChangeThemeTap() {
    setState(() {
      isDark = !isDark;
    });
    themeCubit.changeTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;
    return Drawer(
      backgroundColor: context.cs.surface,
      child: Column(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          _buildHeader(isTablet),
          _buildMenuItems(),
          const Divider(height: 0),
          _buildRole(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final role = Utils.userRole;
    List<DrawerTabModel> tabs = [
      const DrawerTabModel(
        Icons.chat_outlined,
        "ai_chat_bot",
        AiChatBotRoute(),
      ),
      const DrawerTabModel(
        Icons.medical_services_outlined,
        "diagnosing_diseases",
        DiagnosingDiseasesRoute(),
      ),
      const DrawerTabModel(Icons.local_florist_outlined, "crops", CropsRoute()),
      const DrawerTabModel(Icons.eco_outlined, "plants", PlantsRoute()),
      const DrawerTabModel(
        Icons.bug_report_outlined,
        "diseases",
        DiseasesRoute(),
      ),
      const DrawerTabModel(
        Icons.water_drop_outlined,
        "irrigation_schedules",
        IrrigationScheduleRoute(),
      ),
      if (!role.isFarmer)
        const DrawerTabModel(Icons.group_outlined, "users", UsersRoute()),
      const DrawerTabModel(Icons.show_chart_outlined, "stats", StatsRoute()),
      const DrawerTabModel(Icons.person_outlined, "profile", ProfileRoute()),
    ];
    List<Widget> tiles = [];
    final changeLanguageTile = SwitchListTile(
      value: isArabic,
      onChanged: (value) => onChangeLanguageTap(),
      title: const Text("current_language").tr(),
      secondary: const Icon(Icons.translate_outlined, size: 26),
      visualDensity: .compact,
    );

    final changeThemeTile = SwitchListTile(
      value: isDark,
      onChanged: (value) => onChangeThemeTap(),
      title: Text(isDark ? "dark".tr() : "light".tr()),
      secondary: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 26,
      ),
      visualDensity: .compact,
    );

    final logoutTile = ListTile(
      leading: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            MainSnackBar.showSuccessMessage(context, state.message);
          } else if (state is SignInFail) {
            MainSnackBar.showErrorMessage(context, state.error);
          }
        },
        builder: (context, state) {
          Widget child = Icon(Icons.logout, color: context.cs.error, size: 26);
          if (state is SignInLoading) {
            child = SizedBox(
              width: 26,
              child: LoadingIndicator(size: 26, color: context.cs.error),
            );
          }
          return child;
        },
      ),
      title: const Text("logout").tr(),
      onTap: () => context.read<AuthCubit>().signOut(),
    );
    tiles = List.generate(tabs.length, (index) {
      final item = tabs[index];
      bool isActive = false;
      if (context.router.current.name == DashboardRoute.name) {
        isActive = context.tabsRouter.current.name == item.route.routeName;
      } else {
        isActive = context.router.current.name == item.route.routeName;
      }
      return ListTile(
        style: .drawer,
        tileColor: isActive ? context.cs.primaryContainer : context.cs.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppConstants.borderRadius10,
        ),
        leading: Icon(item.icon, size: 26),
        title: Text(item.title).tr(),
        onTap: () {
          Scaffold.maybeOf(context)?.closeDrawer();
          context.router.navigate(item.route);
        },
      );
    });
    tiles.add(changeLanguageTile);
    tiles.add(changeThemeTile);
    tiles.add(logoutTile);
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: AppConstants.paddingH12V4,
        children: tiles,
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: Utils.appImage(context).image()),
          const SizedBox(height: 5),
          Text(
            "Green Mind",
            style: context.tt.headlineSmall?.copyWith(
              color: context.cs.primary,
              fontWeight: .bold,
            ),
            textAlign: .center,
          ),
          const SizedBox(height: 5),
          Text(
            "smart_plant_care_system".tr(),
            style: context.tt.bodyMedium,
            textAlign: .center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildRole() {
    return Padding(
      padding: AppConstants.padding16,
      child: Text("${user.role.displayName}: ${user.username}"),
    );
  }
}
