import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/features/auth/model/user_model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_mind/global/di/di.dart';

part 'auth_manager_event.dart';
part 'auth_manager_state.dart';

@singleton
class AuthManagerBloc extends Bloc<AuthManagerEvent, GeneralAuthManagerState> {
  AuthManagerBloc() : super(InitialAuthManagerState()) {
    on<IsAuthenticatedOrFirstTime>(_findIfAuthenticatedOrFirstTime);
    on<SignInRequested>(_signIn);
    on<SignOutRequested>(_signOut);
  }

  final prefs = get<SharedPreferences>();

  Future<void> _findIfAuthenticatedOrFirstTime(
    IsAuthenticatedOrFirstTime event,
    Emitter<GeneralAuthManagerState> emit,
  ) async {
    final user = prefs.getString("user");
    if (user != null) {
      try {
        final userModel = UserModel.fromString(user);
        emit(AuthenticatedState(userModel));
      } catch (e) {
        emit(UnauthenticatedState());
      }
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _signIn(
    SignInRequested event,
    Emitter<GeneralAuthManagerState> emit,
  ) async {
    await prefs.setString("user", event.user.toString());
    event.onSuccess?.call();
    emit(AuthenticatedState(event.user));
  }

  Future<void> _signOut(
    SignOutRequested event,
    Emitter<GeneralAuthManagerState> emit,
  ) async {
    await prefs.remove("user");
    await prefs.remove("token");
    emit(UnauthenticatedState());
  }
}
