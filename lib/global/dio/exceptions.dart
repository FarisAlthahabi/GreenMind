import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

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
