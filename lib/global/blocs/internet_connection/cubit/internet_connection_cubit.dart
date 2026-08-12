import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'internet_connection_state.dart';

@singleton
class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit() : super(InternetConnectionInitial());

  Future<bool> hasInternet() async {
    bool isConnected = false;
    try {
      final result = await (Connectivity().checkConnectivity());
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        isConnected = true;
      } else {
        isConnected = false;
      }
    } catch (e) {
      isConnected = false;
    }
    return isConnected;
  }

  Future<bool> checkInternet() async {
    emit(CheckInternetLoading());
    final hasNet = await hasInternet();
    if (hasNet) {
      emit(InternetConnectedState("انت الان متصل بالانترنت"));
    } else {
      emit(InternetDisconnectedState("أنت الان بدون اتصال بالانترنت"));
    }
    return hasNet;
  }
}
