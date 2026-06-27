import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:green_mind/features/auth_manager/bloc/auth_manager_bloc.dart';
import 'package:green_mind/global/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_mind/global/utils/logger.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

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
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }
    throw CustomDioException(
      response: err.response,
      error: err.error,
      requestOptions: err.requestOptions,
    );
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions requestOptions)
    : super(requestOptions: requestOptions);

  @override
  String toString() {
    return "unauthorized".tr();
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions requestOptions)
    : super(requestOptions: requestOptions);

  @override
  String toString() {
    return "connection_out".tr();
  }
}

class BadRequestException extends DioException {
  BadRequestException({
    required super.requestOptions,
    required super.response,
    super.message,
  });

  @override
  String toString() {
    return response?.data["message"] ?? "invalid_request".tr();
  }
}

class CustomDioException extends DioException {
  CustomDioException({
    required super.requestOptions,
    required super.response,
    super.error,
    super.type,
    super.message,
  });

  @override
  String toString() {
    try {
      return response?.data?["message"]?.toString() ??
          response?.data ??
          error?.toString() ??
          "something_went_wrong".tr();
    } catch (e) {
      return "something_went_wrong".tr();
    }
  }
}
