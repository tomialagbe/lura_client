import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exceptions.dart';

class ApiClient {
  final Dio dio;
  final String baseUrl;
  final SharedPreferences sharedPrefs;
  final FirebaseAuth firebaseAuth;

  static const accessTokenKey = 'accessToken';

  ApiClient({
    required this.dio,
    required this.baseUrl,
    required this.firebaseAuth,
    required this.sharedPrefs,
  }) {
    dio.options.baseUrl = baseUrl;
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
  }

  Future<Map<String, dynamic>> _enrichHeadersWithAuthToken({
    required Map<String, dynamic> headers,
  }) async {
    final accessToken = await firebaseAuth.currentUser?.getIdToken();
    final enriched = <String, dynamic>{}..addAll(headers);
    if (accessToken != '') {
      enriched['Authorization'] = 'Bearer $accessToken';
    }
    return enriched;
  }

  Future<Response?> get(
    String path, {
    Map<String, String> queryParams = const <String, String>{},
    Map<String, dynamic> headers = const <String, dynamic>{},
    String? tokenOverride,
  }) async {
    try {
      final headersWithAccessToken = await _enrichHeadersWithAuthToken(
        headers: headers,
      );
      final reqPath = path.startsWith('/') ? path : '/$path';
      final response = await dio.get(
        reqPath,
        queryParameters: queryParams,
        options: Options(headers: headersWithAccessToken),
      );
      return response;
    } on DioError catch (e) {
      _handleDioError(e);
      return null;
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  Future<Response?> post(
    String path, {
    dynamic data,
    Map<String, dynamic> headers = const <String, dynamic>{},
    String? tokenOverride,
  }) async {
    try {
      final headersWithAccessToken =
          await _enrichHeadersWithAuthToken(headers: headers);
      final reqPath = path.startsWith('/') ? path : '/$path';
      final response = await dio.post(
        reqPath,
        data: data,
        options: Options(headers: headersWithAccessToken),
      );
      return response;
    } on DioError catch (e) {
      _handleDioError(e);
      return null;
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  Future<Response?> delete(
    String path, {
    Map<String, String> queryParams = const <String, String>{},
    Map<String, dynamic> headers = const <String, dynamic>{},
  }) async {
    try {
      final headersWithAccessToken = await _enrichHeadersWithAuthToken(
        headers: headers,
      );
      final reqPath = path.startsWith('/') ? path : '/$path';
      final response = await dio.delete(
        reqPath,
        queryParameters: queryParams,
        options: Options(headers: headersWithAccessToken),
      );
      return response;
    } on DioError catch (e) {
      _handleDioError(e);
      return null;
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  void _handleDioError(DioError e) {
    // debugPrint(e.toString());
    switch (e.type) {
      case DioErrorType.response:
        throw ResponseException(
            statusCode: e.response!.statusCode!,
            responseMessage: e.response?.data.toString(),
            message: e.message);
      case DioErrorType.connectTimeout:
        throw ConnectTimeoutException(e.message);
      case DioErrorType.receiveTimeout:
      default:
        throw ResponseTimeoutException(e.message);
    }
  }
}
