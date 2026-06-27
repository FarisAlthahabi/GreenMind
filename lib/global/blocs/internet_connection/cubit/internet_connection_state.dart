part of 'internet_connection_cubit.dart';

@immutable
sealed class InternetConnectionState {}

final class InternetConnectionInitial extends InternetConnectionState {}

final class CheckInternetLoading extends InternetConnectionState {}

final class InternetConnectedState extends InternetConnectionState {
  final String message;

  InternetConnectedState(this.message);
}

final class InternetDisconnectedState extends InternetConnectionState {
  final String message;

  InternetDisconnectedState(this.message);
}

final class CheckInternetFail extends InternetConnectionState {
  final String error;

  CheckInternetFail(this.error);
}
