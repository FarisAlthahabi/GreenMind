// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:green_mind/features/app_manager/cubit/app_manager_cubit.dart'
    as _i864;
import 'package:green_mind/features/auth/cubit/auth_cubit.dart' as _i886;
import 'package:green_mind/features/auth/service/auth_service.dart' as _i766;
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart'
    as _i753;
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart'
    as _i749;
import 'package:green_mind/global/di/app_module.dart' as _i807;
import 'package:green_mind/global/dio/dio_client.dart' as _i645;
import 'package:green_mind/global/theme/cubit/theme_cubit.dart' as _i696;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i864.AppManagerCubit>(() => _i864.AppManagerCubit());
    gh.singleton<_i753.AuthManagerBloc>(() => _i753.AuthManagerBloc());
    gh.singleton<_i749.InternetConnectionCubit>(
      () => _i749.InternetConnectionCubit(),
    );
    gh.singleton<_i645.DioClient>(() => _i645.DioClient());
    gh.factory<_i766.SignInService>(() => _i766.SignInServiceImp());
    gh.factory<_i696.ThemeCubit>(
      () => _i696.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i886.AuthCubit>(
      () => _i886.AuthCubit(
        gh<_i766.SignInService>(),
        gh<_i753.AuthManagerBloc>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i807.AppModule {}
