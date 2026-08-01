import 'package:auto_route/auto_route.dart';
import 'package:green_mind/global/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View|Tab|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: SplashRoute.page,
    ),
    AdaptiveRoute(
      page: AuthManagerRoute.page,
      children: [
        AdaptiveRoute(
          page: AuthRouter.page,
          children: [
            AutoRoute(page: SignInRoute.page, initial: true),
            // AutoRoute(page: SignUpRoute.page),
            // AutoRoute(page: VerifyRoute.page),
            // AutoRoute(page: ForgetPasswordRoute.page),
            // AutoRoute(page: ResetPasswordRoute.page),
          ],
        ),
        AdaptiveRoute(
          page: AppManagerRoute.page,
          children: [
            AutoRoute(
              initial: true,
              page: DashboardRoute.page,
              children: [
                AutoRoute(initial: true, page: AiChatBotRoute.page),
                AutoRoute(page: DiagnosingDiseasesRoute.page),
              ],
            ),
            AutoRoute(page: CropsRoute.page),
            AutoRoute(page: PlantsRoute.page),
            AutoRoute(page: IrrigationScheduleRoute.page),
            AutoRoute(page: UsersRoute.page),
            AutoRoute(page: StatsRoute.page),
          ],
        ),
      ],
    ),
  ];
}
