// lib/data/apis/dio_client.dart

import 'package:dio/dio.dart';
import '../api_constants/api_url_constants.dart';
import 'storage_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrlConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
        // ✅ This tells Dio NOT to throw on 404
        // Each service handles status codes manually
        validateStatus: (status) {
          // Accept any status so we handle them ourselves in each service
          return status != null && status < 500;
        },
      ),
    );

    // Auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Auto logout ONLY on 401 Unauthorized
          if (error.response?.statusCode == 401) {
            StorageService().clearAll();
            // Get.offAllNamed(Routes.LOGIN);
          }
          return handler.next(error);
        },
      ),
    );

    // Logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }
}