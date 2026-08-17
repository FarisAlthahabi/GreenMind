import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart';
import 'package:green_mind/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:green_mind/global/dio/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_mind/global/utils/logger.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!await get<InternetConnectionCubit>().hasInternet()) {
      return handler.reject(NoInternetException(requestOptions: options));
    }

    if (!options.headers.containsKey('Accept')) {
      options.headers['Accept'] = 'application/json';
    }

    final prefs = await SharedPreferences.getInstance();
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final locale = prefs.getString('locale') ?? deviceLocale.languageCode;
    // final locale = prefs.getString('locale') ?? 'ar';

    final token = prefs.getString("token");
    options.headers['Accept-Language'] = locale;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('Bearer $token');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.f(
      'Message: ${err.message}\n'
      'Error: ${err.error}\n'
      'Status code: ${err.response?.statusCode}\n'
      'Type: ${err.type}\n'
      'Response: ${err.response?.data}',
    );
    if (err.response?.statusCode == 401) {
      get<AuthManagerBloc>().add(SignOutRequested());
      throw UnauthorizedException(err.requestOptions);
    }
    if (err.type == .connectionTimeout || err.type == .receiveTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }
    if (err.type == .connectionError) {
      throw ConnectionToServerError(err.requestOptions);
    }
    if (err.type == .unknown) {
      throw UnknownException(err.requestOptions);
    }
    if (err.response?.statusCode == 500) {
      throw InternalServerError(err.requestOptions);
    }
    throw CustomDioException(
      response: err.response,
      error: err.error,
      requestOptions: err.requestOptions,
    );
  }
}
