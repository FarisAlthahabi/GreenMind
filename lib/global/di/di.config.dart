// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:green_mind/features/ai_chat_bot/cubit/ai_chat_bot_cubit.dart'
    as _i123;
import 'package:green_mind/features/ai_chat_bot/service/ai_chat_bot_service.dart'
    as _i209;
import 'package:green_mind/features/app_manager/cubit/app_manager_cubit.dart'
    as _i864;
import 'package:green_mind/features/auth/cubit/auth_cubit.dart' as _i886;
import 'package:green_mind/features/auth/service/auth_service.dart' as _i766;
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart'
    as _i753;
import 'package:green_mind/features/crops/cubit/crops_cubit.dart' as _i901;
import 'package:green_mind/features/crops/service/crops_service.dart' as _i702;
import 'package:green_mind/features/diagnosing_diseases/cubit/diagnosing_diseases_cubit.dart'
    as _i105;
import 'package:green_mind/features/diagnosing_diseases/service/diagnosing_diseases_service.dart'
    as _i593;
import 'package:green_mind/features/diseases/cubit/diseases_cubit.dart'
    as _i812;
import 'package:green_mind/features/diseases/service/diseases_service.dart'
    as _i622;
import 'package:green_mind/features/inventory/cubit/inventory_cubit.dart'
    as _i454;
import 'package:green_mind/features/inventory/service/inventory_service.dart'
    as _i85;
import 'package:green_mind/features/inventory_activity/cubit/inventory_activity_cubit.dart'
    as _i873;
import 'package:green_mind/features/inventory_activity/service/inventory_activity_service.dart'
    as _i835;
import 'package:green_mind/features/irrigation_schedule/cubit/irrigation_schedule_cubit.dart'
    as _i1008;
import 'package:green_mind/features/irrigation_schedule/service/irrigation_schedule_service.dart'
    as _i1010;
import 'package:green_mind/features/plants/cubit/plants_cubit.dart' as _i29;
import 'package:green_mind/features/plants/service/plants_service.dart'
    as _i574;
import 'package:green_mind/features/profile/cubit/profile_cubit.dart' as _i70;
import 'package:green_mind/features/profile/service/profile_service.dart'
    as _i344;
import 'package:green_mind/features/stats/cubit/stats_cubit.dart' as _i214;
import 'package:green_mind/features/stats/service/stats_service.dart' as _i529;
import 'package:green_mind/features/users/cubit/users_cubit.dart' as _i814;
import 'package:green_mind/features/users/service/users_service.dart' as _i671;
import 'package:green_mind/global/blocs/delete_cubit/cubit/delete_cubit.dart'
    as _i804;
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart'
    as _i749;
import 'package:green_mind/global/blocs/upload_image_cubit/cubit/upload_image_cubit.dart'
    as _i872;
import 'package:green_mind/global/di/app_module.dart' as _i807;
import 'package:green_mind/global/services/delete_service/delete_service.dart'
    as _i869;
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
    gh.factory<_i872.UploadImageCubit>(() => _i872.UploadImageCubit());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i864.AppManagerCubit>(() => _i864.AppManagerCubit());
    gh.singleton<_i753.AuthManagerBloc>(() => _i753.AuthManagerBloc());
    gh.singleton<_i749.InternetConnectionCubit>(
      () => _i749.InternetConnectionCubit(),
    );
    gh.factory<_i209.AiChatBotService>(() => _i209.AiChatBotServiceImp());
    gh.factory<_i622.DiseasesService>(() => _i622.DiseasesServiceImp());
    gh.factory<_i529.StatsService>(() => _i529.StatsServiceImp());
    gh.factory<_i835.InventoryActivityService>(
      () => _i835.InventoryActivityServiceImp(),
    );
    gh.factory<_i214.StatsCubit>(
      () => _i214.StatsCubit(gh<_i529.StatsService>()),
    );
    gh.factory<_i574.PlantsService>(() => _i574.PlantsServiceImp());
    gh.factory<_i671.UsersService>(() => _i671.UsersServiceImp());
    gh.factory<_i766.SignInService>(() => _i766.SignInServiceImp());
    gh.factory<_i593.DiagnosingDiseasesService>(
      () => _i593.DiagnosingDiseasesServiceImp(),
    );
    gh.factory<_i1010.IrrigationScheduleService>(
      () => _i1010.IrrigationScheduleServiceImp(),
    );
    gh.factory<_i814.UsersCubit>(
      () => _i814.UsersCubit(usersService: gh<_i671.UsersService>()),
    );
    gh.factory<_i123.AiChatBotCubit>(
      () =>
          _i123.AiChatBotCubit(aiChatBotService: gh<_i209.AiChatBotService>()),
    );
    gh.factory<_i344.ProfileService>(() => _i344.ProfileServiceImp());
    gh.factory<_i702.CropsService>(() => _i702.CropsServiceImp());
    gh.factory<_i869.DeleteService>(() => _i869.DeleteServiceImp());
    gh.factory<_i85.InventoryService>(() => _i85.InventoryServiceImp());
    gh.factory<_i873.InventoryActivityCubit>(
      () => _i873.InventoryActivityCubit(
        service: gh<_i835.InventoryActivityService>(),
      ),
    );
    gh.factory<_i454.InventoryCubit>(
      () => _i454.InventoryCubit(inventoryService: gh<_i85.InventoryService>()),
    );
    gh.factory<_i1008.IrrigationScheduleCubit>(
      () => _i1008.IrrigationScheduleCubit(
        service: gh<_i1010.IrrigationScheduleService>(),
      ),
    );
    gh.factory<_i696.ThemeCubit>(
      () => _i696.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i901.CropsCubit>(
      () => _i901.CropsCubit(cropsService: gh<_i702.CropsService>()),
    );
    gh.factory<_i812.DiseasesCubit>(
      () => _i812.DiseasesCubit(diseasesService: gh<_i622.DiseasesService>()),
    );
    gh.factory<_i804.DeleteCubit>(
      () => _i804.DeleteCubit(gh<_i869.DeleteService>()),
    );
    gh.factory<_i886.AuthCubit>(
      () => _i886.AuthCubit(
        gh<_i766.SignInService>(),
        gh<_i753.AuthManagerBloc>(),
      ),
    );
    gh.factory<_i105.DiagnosingDiseasesCubit>(
      () => _i105.DiagnosingDiseasesCubit(
        service: gh<_i593.DiagnosingDiseasesService>(),
      ),
    );
    gh.factory<_i29.PlantsCubit>(
      () => _i29.PlantsCubit(plantService: gh<_i574.PlantsService>()),
    );
    gh.factory<_i70.ProfileCubit>(
      () => _i70.ProfileCubit(profileService: gh<_i344.ProfileService>()),
    );
    return this;
  }
}

class _$AppModule extends _i807.AppModule {}
