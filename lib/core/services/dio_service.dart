import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class DioService {
  static final _dio = Dio();

  //GET METHOD
  static Future<ApiResponseModel> getMethod({
    required String url,
    required Map<String, String> headers,
  }) async {
    try {
      debugPrint('-----------------------------------------------');
      debugPrint('GET METHOD URL : $url');
      final response = await _dio.get(url, options: Options(headers: headers));
      debugPrint('OUTPUT : ${response.data}');
      return ApiResponseModel(success: true, data: response.data);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      dynamic errorData = e.response?.data;

      debugPrint('STATUS CODE: $statusCode');
      debugPrint('ERROR DATA : $errorData');

      if (statusCode == 400) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Bad Request',
        );
      } else if (statusCode == 404) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Page Not Found',
        );
      } else if (statusCode == 500) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Internal Server Error',
        );
      }

      return ApiResponseModel(
        success: false,
        data: null,
        error: 'Something went wrong',
      );
    }
  }

  //POST METHOD
  static Future<ApiResponseModel> postMethod({
    required String url,
    required Map<String, String> headers,
    required dynamic input,
  }) async {
    try {
      debugPrint('-----------------------------------------------');
      debugPrint('POST METHOD URL : $url');
      debugPrint('INPUT : $input');
      final response = await _dio.post(
        url,
        options: Options(headers: headers),
        data: input,
      );
      debugPrint('OUTPUT : ${response.data}');
      return ApiResponseModel(success: true, data: response.data);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      dynamic errorData = e.response?.data;

      debugPrint('STATUS CODE: $statusCode');
      debugPrint('ERROR DATA : $errorData');

      if (statusCode == 400) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Bad Request',
        );
      } else if (statusCode == 404) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Page Not Found',
        );
      } else if (statusCode == 500) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Internal Server Error',
        );
      }

      return ApiResponseModel(
        success: false,
        data: null,
        error: 'Something went wrong',
      );
    }
  }

  //PATCH METHOD
  static Future<ApiResponseModel> patchMethod({
    required String url,
    required Map<String, String> headers,
    required dynamic input,
  }) async {
    try {
      debugPrint('-----------------------------------------------');
      debugPrint('PATCH METHOD URL : $url');
      debugPrint('INPUT : $input');
      final response = await _dio.patch(
        url,
        options: Options(headers: headers),
        data: input,
      );
      debugPrint('OUTPUT : ${response.data}');
      return ApiResponseModel(success: true, data: response.data);
    } on DioException catch (e) {
      int? statusCode = e.response?.statusCode;
      dynamic errorData = e.response?.data;

      debugPrint('STATUS CODE: $statusCode');
      debugPrint('ERROR DATA : $errorData');

      if (statusCode == 400) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Bad Request',
        );
      } else if (statusCode == 404) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Page Not Found',
        );
      } else if (statusCode == 500) {
        return ApiResponseModel(
          success: false,
          data: null,
          error: 'Internal Server Error',
        );
      }

      return ApiResponseModel(
        success: false,
        data: null,
        error: 'Something went wrong',
      );
    }
  }
}

//<----------------------------------->

class ApiResponseModel {
  final bool success;
  final dynamic data;
  final String error;

  ApiResponseModel({
    required this.success,
    required this.data,
    this.error = '',
  });
}
