part of 'auth_manager_bloc.dart';

abstract class AuthManagerEvent {
  const AuthManagerEvent();
}

class IsAuthenticatedOrFirstTime extends AuthManagerEvent {}

class ShowSignIn extends AuthManagerEvent {
  const ShowSignIn({this.showBackButton = false, this.onSignedIn});

  final bool showBackButton;
  final VoidCallback? onSignedIn;
}

class SignInRequested extends AuthManagerEvent {
  const SignInRequested(this.user, {this.onSuccess, this.isSignIn = true});

  final UserModel user;
  final VoidCallback? onSuccess;
  final bool isSignIn;
}

class SignOutRequested extends AuthManagerEvent {}

class VerifyRequested extends AuthManagerEvent {
  const VerifyRequested(this.email, this.message);

  final String email;
  final String message;
}

class ForgetPasswordRequested extends AuthManagerEvent {
  const ForgetPasswordRequested();
}
