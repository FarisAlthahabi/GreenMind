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
    if (isArabic) {
      context.setLocale(SupportedLocales.arabic);
    } else {
      context.setLocale(SupportedLocales.english);
    }
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
      child: Column(children: [_buildHeader(isTablet), _buildMenuItems()]),
    );
  }

  Widget _buildMenuItems() {
    List<DrawerTabModel> tabs = [
      const DrawerTabModel(Icons.show_chart, "stats", StatsRoute()),
    ];
    List<Widget> tiles = [];
    final changeLanguageTile = SwitchListTile(
      value: isArabic,
      onChanged: (value) => onChangeLanguageTap(),
      title: Text("current_language".tr()),
      secondary: Icon(Icons.translate_outlined, size: 26),
      visualDensity: VisualDensity.compact,
    );

    final changeThemeTile = SwitchListTile(
      value: isDark,
      onChanged: (value) => onChangeThemeTap(),
      title: Text(isDark ? "dark".tr() : "light".tr()),
      secondary: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 26,
      ),
      visualDensity: VisualDensity.compact,
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
      title: Text("logout").tr(),
      onTap: () => context.read<AuthCubit>().signOut(),
    );
    tiles = List.generate(tabs.length, (index) {
      final item = tabs[index];
      return ListTile(
        dense: true,
        leading: Icon(item.icon, size: 26),
        title: Text(item.title).tr(),
        onTap: () => context.router.push(item.route),
      );
    });
    tiles.add(changeLanguageTile);
    tiles.add(changeThemeTile);
    tiles.add(logoutTile);
    return Expanded(
      child: ListView(padding: AppConstants.padding4, children: tiles),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(child: Utils.appImage(context).image()),
          SizedBox(height: 5),
          Text(
            "Green Mind",
            style: context.tt.headlineSmall?.copyWith(
              color: context.cs.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: .center,
          ),
          SizedBox(height: 5),
          Text(
            "smart_plant_care_system".tr(),
            style: context.tt.bodyMedium,
            textAlign: .center,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
