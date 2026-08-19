import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:green_mind/global/dio/app_interceptor.dart';
import 'package:green_mind/global/utils/constants.dart';

// const baseUrl = "http://127.0.0.1:8000";
// const baseUrl = "http://192.168.1.36:8000";
const appIP = "192.168.1.111";
// const baseUrl = "http://$appIP:8000";
const baseUrl = "https://lazy-yard-dingo.ngrok-free.dev";
const apiUrl = '$baseUrl/api/';
// const apiUrl = '$baseUrl/';

class DioClient {
  factory DioClient() {
    return _instance;
  }

  DioClient._() {
    final baseOptions = BaseOptions(
      baseUrl: apiUrl,
      receiveTimeout: AppConstants.duration15s,
      connectTimeout: AppConstants.duration15s,
      sendTimeout: AppConstants.duration15s,
      // responseType: .stream
    );

    _dio = Dio(baseOptions);
    _dio.interceptors.add(AppInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
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
    ResponseType? responseType = .json,
  }) async {
    _dio.options = _dio.options.copyWith(
      receiveTimeout: duration,
      connectTimeout: duration,
      sendTimeout: duration,
      responseType: responseType,
    );

    return _dio.get(
      endpoint,
      queryParameters: queries,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response<dynamic>> postStreaming(
    String endpoint, {
    Map<String, dynamic>? queries,
    dynamic data,
    // Map<String, dynamic>? headers,
    Duration? duration,
  }) async {
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
    };
    return post(
      endpoint,
      queries: queries,
      data: data,
      headers: requestHeaders,
      duration: duration,
      responseType: .stream,
    );
  }

  Future<Response<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? queries,
    dynamic data,
    Options? options,
    Map<String, dynamic>? headers,
    Duration? duration,
    ResponseType? responseType = .json,
  }) async {
    _dio.options = _dio.options.copyWith(
      receiveTimeout: duration,
      connectTimeout: duration,
      sendTimeout: duration,
      responseType: responseType,
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
    ResponseType? responseType = .json,
  }) async {
    _dio.options = _dio.options.copyWith(responseType: responseType);
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
    ResponseType? responseType = .json,
  }) async {
    _dio.options = _dio.options.copyWith(responseType: responseType);
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
    ResponseType? responseType = .json,
  }) async {
    _dio.options = _dio.options.copyWith(responseType: responseType);
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
