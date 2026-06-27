part of 'auth_manager_bloc.dart';

abstract class GeneralAuthManagerState {
  const GeneralAuthManagerState();
}

class InitialAuthManagerState extends GeneralAuthManagerState {}

class ShowSignInState extends GeneralAuthManagerState {
  const ShowSignInState({this.action});

  final VoidCallback? action;
}

class AuthenticatedState extends GeneralAuthManagerState {
  final UserModel user;
  AuthenticatedState(this.user);
}

// class SignedUpState extends GeneralAuthManagerState {
//   final SignInModel user;

//   SignedUpState(this.user);
// }

class UnauthenticatedState extends GeneralAuthManagerState {}