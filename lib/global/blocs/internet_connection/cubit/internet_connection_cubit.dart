import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'internet_connection_state.dart';

@singleton
class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit() : super(InternetConnectionInitial());

  Future<bool> checkInternetConnection() async {
    bool isConnected = false;
    emit(CheckInternetLoading());
    try {
      final List<ConnectivityResult> result =
          await (Connectivity().checkConnectivity());
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        isConnected = true;
        emit(InternetConnectedState("انت الان متصل بالانترنت"));
      } else {
        isConnected = false;
        emit(InternetDisconnectedState("أنت الان بدون اتصال بالانترنت"));
      }
    } catch (e) {
      isConnected = false;
      emit(CheckInternetFail(e.toString()));
    }
    return isConnected;
  }
}
