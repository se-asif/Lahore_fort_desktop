import 'package:dio/dio.dart';
import '../utils/Constants.dart';

class DioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      // Change this to your API base URL
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ),

  );
  String get baseUrl => _dio.options.baseUrl;

  Future<Response> getRequest(String endpoint, Map<String, dynamic> data, {Options? options}) async {
      try {
        Response response = await _dio.get(endpoint, data: data, options: options);
        return response;
      } catch (e) {
        throw Exception('Failed to load data: $e');
      }
    }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> data, {Options? options}) async {
    try {
      Response response = await _dio.post(endpoint, data: data, options: options);
      print("response $response");
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

}