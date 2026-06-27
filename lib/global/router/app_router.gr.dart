// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:green_mind/features/app_manager/view/app_manager_view.dart'
    as _i1;
import 'package:green_mind/features/auth/model/user_model/user_model.dart'
    as _i9;
import 'package:green_mind/features/auth/view/auth_router.dart' as _i3;
import 'package:green_mind/features/auth/view/sign_in_view.dart' as _i4;
import 'package:green_mind/features/auth/view/sign_up_view.dart' as _i5;
import 'package:green_mind/features/auth_manager/view/auth_manager_view.dart'
    as _i2;
import 'package:green_mind/features/splash/view/splash_view.dart' as _i6;

/// generated route for
/// [_i1.AppManagerView]
class AppManagerRoute extends _i7.PageRouteInfo<AppManagerRouteArgs> {
  AppManagerRoute({
    _i8.Key? key,
    required _i9.UserModel user,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         AppManagerRoute.name,
         args: AppManagerRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'AppManagerRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppManagerRouteArgs>();
      return _i1.AppManagerView(key: args.key, user: args.user);
    },
  );
}

class AppManagerRouteArgs {
  const AppManagerRouteArgs({this.key, required this.user});

  final _i8.Key? key;

  final _i9.UserModel user;

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
/// [_i2.AuthManagerView]
class AuthManagerRoute extends _i7.PageRouteInfo<void> {
  const AuthManagerRoute({List<_i7.PageRouteInfo>? children})
    : super(AuthManagerRoute.name, initialChildren: children);

  static const String name = 'AuthManagerRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthManagerView();
    },
  );
}

/// generated route for
/// [_i3.AuthRouter]
class AuthRouter extends _i7.PageRouteInfo<void> {
  const AuthRouter({List<_i7.PageRouteInfo>? children})
    : super(AuthRouter.name, initialChildren: children);

  static const String name = 'AuthRouter';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.AuthRouter();
    },
  );
}

/// generated route for
/// [_i4.SignInView]
class SignInRoute extends _i7.PageRouteInfo<void> {
  const SignInRoute({List<_i7.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignInView();
    },
  );
}

/// generated route for
/// [_i5.SignUpView]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpView();
    },
  );
}

/// generated route for
/// [_i6.SplashView]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SplashView();
    },
  );
}
