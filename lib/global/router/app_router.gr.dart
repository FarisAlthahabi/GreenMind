// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:flutter/material.dart' as _i21;
import 'package:green_mind/features/ai_chat_bot/view/ai_chat_bot.dart' as _i1;
import 'package:green_mind/features/app_manager/view/app_manager_view.dart'
    as _i2;
import 'package:green_mind/features/auth/model/user_model/user_model.dart'
    as _i22;
import 'package:green_mind/features/auth/view/auth_router.dart' as _i5;
import 'package:green_mind/features/auth/view/sign_in_view.dart' as _i16;
import 'package:green_mind/features/auth_manager/view/auth_manager_view.dart'
    as _i4;
import 'package:green_mind/features/crops/view/crop_view.dart' as _i6;
import 'package:green_mind/features/dashboard/view/dashboard_view.dart' as _i7;
import 'package:green_mind/features/diagnosing_diseases/view/diagnoses_diseases_view.dart'
    as _i8;
import 'package:green_mind/features/diagnosing_diseases/view/diagnosing_diseases_view.dart'
    as _i9;
import 'package:green_mind/features/diseases/view/diseases_view.dart' as _i10;
import 'package:green_mind/features/inventory/view/inventory_view.dart' as _i12;
import 'package:green_mind/features/inventory_activity/view/inventory_activity_view.dart'
    as _i11;
import 'package:green_mind/features/irrigation_schedule/view/irrigation_schedule_view.dart'
    as _i13;
import 'package:green_mind/features/plants/view/plants_view.dart' as _i14;
import 'package:green_mind/features/profile/view/profile_view.dart' as _i15;
import 'package:green_mind/features/splash/view/splash_view.dart' as _i17;
import 'package:green_mind/features/stats/view/stats_view.dart' as _i18;
import 'package:green_mind/features/users/view/audit_logs_view.dart' as _i3;
import 'package:green_mind/features/users/view/users_view.dart' as _i19;

/// generated route for
/// [_i1.AiChatBotView]
class AiChatBotRoute extends _i20.PageRouteInfo<void> {
  const AiChatBotRoute({List<_i20.PageRouteInfo>? children})
    : super(AiChatBotRoute.name, initialChildren: children);

  static const String name = 'AiChatBotRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i1.AiChatBotView();
    },
  );
}

/// generated route for
/// [_i2.AppManagerView]
class AppManagerRoute extends _i20.PageRouteInfo<AppManagerRouteArgs> {
  AppManagerRoute({
    _i21.Key? key,
    required _i22.UserModel user,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         AppManagerRoute.name,
         args: AppManagerRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'AppManagerRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppManagerRouteArgs>();
      return _i2.AppManagerView(key: args.key, user: args.user);
    },
  );
}

class AppManagerRouteArgs {
  const AppManagerRouteArgs({this.key, required this.user});

  final _i21.Key? key;

  final _i22.UserModel user;

  @override
  String toString() {
    return 'AppManagerRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppManagerRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i3.AuditLogsView]
class AuditLogsRoute extends _i20.PageRouteInfo<AuditLogsRouteArgs> {
  AuditLogsRoute({
    _i21.Key? key,
    required int userId,
    List<_i20.PageRouteInfo>? children,
  }) : super(
         AuditLogsRoute.name,
         args: AuditLogsRouteArgs(key: key, userId: userId),
         initialChildren: children,
       );

  static const String name = 'AuditLogsRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuditLogsRouteArgs>();
      return _i3.AuditLogsView(key: args.key, userId: args.userId);
    },
  );
}

class AuditLogsRouteArgs {
  const AuditLogsRouteArgs({this.key, required this.userId});

  final _i21.Key? key;

  final int userId;

  @override
  String toString() {
    return 'AuditLogsRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuditLogsRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [_i4.AuthManagerView]
class AuthManagerRoute extends _i20.PageRouteInfo<void> {
  const AuthManagerRoute({List<_i20.PageRouteInfo>? children})
    : super(AuthManagerRoute.name, initialChildren: children);

  static const String name = 'AuthManagerRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i4.AuthManagerView();
    },
  );
}

/// generated route for
/// [_i5.AuthRouter]
class AuthRouter extends _i20.PageRouteInfo<void> {
  const AuthRouter({List<_i20.PageRouteInfo>? children})
    : super(AuthRouter.name, initialChildren: children);

  static const String name = 'AuthRouter';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i5.AuthRouter();
    },
  );
}

/// generated route for
/// [_i6.CropsView]
class CropsRoute extends _i20.PageRouteInfo<void> {
  const CropsRoute({List<_i20.PageRouteInfo>? children})
    : super(CropsRoute.name, initialChildren: children);

  static const String name = 'CropsRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i6.CropsView();
    },
  );
}

/// generated route for
/// [_i7.DashboardView]
class DashboardRoute extends _i20.PageRouteInfo<void> {
  const DashboardRoute({List<_i20.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardView();
    },
  );
}

/// generated route for
/// [_i8.DiagnosesView]
class DiagnosesRoute extends _i20.PageRouteInfo<void> {
  const DiagnosesRoute({List<_i20.PageRouteInfo>? children})
    : super(DiagnosesRoute.name, initialChildren: children);

  static const String name = 'DiagnosesRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i8.DiagnosesView();
    },
  );
}

/// generated route for
/// [_i9.DiagnosingDiseasesView]
class DiagnosingDiseasesRoute extends _i20.PageRouteInfo<void> {
  const DiagnosingDiseasesRoute({List<_i20.PageRouteInfo>? children})
    : super(DiagnosingDiseasesRoute.name, initialChildren: children);

  static const String name = 'DiagnosingDiseasesRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i9.DiagnosingDiseasesView();
    },
  );
}

/// generated route for
/// [_i10.DiseasesView]
class DiseasesRoute extends _i20.PageRouteInfo<void> {
  const DiseasesRoute({List<_i20.PageRouteInfo>? children})
    : super(DiseasesRoute.name, initialChildren: children);

  static const String name = 'DiseasesRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i10.DiseasesView();
    },
  );
}

/// generated route for
/// [_i11.InventoryActivityView]
class InventoryActivityRoute extends _i20.PageRouteInfo<void> {
  const InventoryActivityRoute({List<_i20.PageRouteInfo>? children})
    : super(InventoryActivityRoute.name, initialChildren: children);

  static const String name = 'InventoryActivityRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i11.InventoryActivityView();
    },
  );
}

/// generated route for
/// [_i12.InventoryView]
class InventoryRoute extends _i20.PageRouteInfo<void> {
  const InventoryRoute({List<_i20.PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i12.InventoryView();
    },
  );
}

/// generated route for
/// [_i13.IrrigationScheduleView]
class IrrigationScheduleRoute extends _i20.PageRouteInfo<void> {
  const IrrigationScheduleRoute({List<_i20.PageRouteInfo>? children})
    : super(IrrigationScheduleRoute.name, initialChildren: children);

  static const String name = 'IrrigationScheduleRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i13.IrrigationScheduleView();
    },
  );
}

/// generated route for
/// [_i14.PlantsView]
class PlantsRoute extends _i20.PageRouteInfo<void> {
  const PlantsRoute({List<_i20.PageRouteInfo>? children})
    : super(PlantsRoute.name, initialChildren: children);

  static const String name = 'PlantsRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i14.PlantsView();
    },
  );
}

/// generated route for
/// [_i15.ProfileView]
class ProfileRoute extends _i20.PageRouteInfo<void> {
  const ProfileRoute({List<_i20.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i15.ProfileView();
    },
  );
}

/// generated route for
/// [_i16.SignInView]
class SignInRoute extends _i20.PageRouteInfo<void> {
  const SignInRoute({List<_i20.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i16.SignInView();
    },
  );
}

/// generated route for
/// [_i17.SplashView]
class SplashRoute extends _i20.PageRouteInfo<void> {
  const SplashRoute({List<_i20.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i17.SplashView();
    },
  );
}

/// generated route for
/// [_i18.StatsView]
class StatsRoute extends _i20.PageRouteInfo<void> {
  const StatsRoute({List<_i20.PageRouteInfo>? children})
    : super(StatsRoute.name, initialChildren: children);

  static const String name = 'StatsRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i18.StatsView();
    },
  );
}

/// generated route for
/// [_i19.UsersView]
class UsersRoute extends _i20.PageRouteInfo<void> {
  const UsersRoute({List<_i20.PageRouteInfo>? children})
    : super(UsersRoute.name, initialChildren: children);

  static const String name = 'UsersRoute';

  static _i20.PageInfo page = _i20.PageInfo(
    name,
    builder: (data) {
      return const _i19.UsersView();
    },
  );
}
