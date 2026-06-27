import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:green_mind/global/dio/app_interceptor.dart';
import 'package:green_mind/global/utils/constants.dart';

const baseUrl = "http://192.168.1.222:8000";
const apiUrl = '$baseUrl/api/';
// const apiUrl = '$baseUrl/';

@singleton
class DioClient {
  factory DioClient() {
    return _instance;
  }

  DioClient._() {
    final baseOptions = BaseOptions(
      baseUrl: apiUrl,
      receiveTimeout: AppConstants.duration25s,
      connectTimeout: AppConstants.duration25s,
      sendTimeout: AppConstants.duration25s,
    );

    _dio = Dio(baseOptions);
    _dio.interceptors.add(AppInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        maxWidth: 98,
        compact: true,
        logPrint: dioPrint,
      ),
    );
  }

  static final DioClient _instance = DioClient._();

  late final Dio _dio;

  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queries,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
    Duration? duration,

    Options? options,
  }) async {
    if (duration != null) {
      _dio.options = _dio.options.copyWith(
        receiveTimeout: duration,
        connectTimeout: duration,
        sendTimeout: duration,
      );
    }

    final mergedHeaders = <String, dynamic>{
      ...(options?.headers ?? {}),
      ...(headers ?? {}),
    };

    final effectiveOptions = (options ?? Options()).copyWith(
      headers: mergedHeaders,
    );

    return _dio.get(
      endpoint,
      queryParameters: queries,
      data: data,
      options: effectiveOptions,
    );
  }

  Future<Response<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? queries,
    dynamic data,
    Map<String, dynamic>? headers,
    Duration? duration,
  }) async {
    _dio.options = _dio.options.copyWith(
      receiveTimeout: duration,
      connectTimeout: duration,
      sendTimeout: duration,
    );
    return _dio.post(
      endpoint,
      queryParameters: queries,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.put(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.patch(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.delete(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> postOrPut(
    String endpoint, {
    required bool isAdd,
    Map<String, dynamic>? queries,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    if (isAdd) {
      return _dio.post(
        endpoint,
        queryParameters: queries,
        data: data,
        options: Options(headers: headers),
      );
    } else {
      return _dio.put(
        endpoint,
        queryParameters: queries,
        data: data,
        options: Options(headers: headers),
      );
    }
  }
}

void dioPrint(Object object) {
  debugPrint(object.toString());
}
