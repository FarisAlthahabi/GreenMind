import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'states/app_manager_state.dart';

@singleton
class AppManagerCubit extends Cubit<AppManagerState> {
  AppManagerCubit() : super(AppManagerInitial());
}
