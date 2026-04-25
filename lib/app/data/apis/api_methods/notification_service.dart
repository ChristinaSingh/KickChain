// lib/data/apis/api_methods/notification_service.dart

import 'package:dio/dio.dart';
import '../api_constants/api_url_constants.dart';
import '../api_models/notification_model.dart';
import '../api_models/notification_response_model.dart';
import 'dio_client.dart';

class NotificationService {
  final Dio _dio = DioClient().dio;

  /// GET /notification/my
  /// Fetches all notifications for the current user
  /// Returns empty list if 404 (no notifications found)
  Future<List<NotificationModel>> getMyNotifications() async {
    try {
      final response = await _dio.get(
        ApiUrlConstants.endPointOfMyNotifications,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseModel = NotificationListResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return responseModel.data;
      }

      // 404 means no notifications found → return empty list (not an error)
      if (response.statusCode == 404) {
        return [];
      }

      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      // 404 from Dio bad response → treat as empty list
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// PATCH /notification/read/:id
  /// Marks a single notification as read
  Future<NotificationModel?> markNotificationAsRead(
      String notificationId) async {
    try {
      final response = await _dio.patch(
        '${ApiUrlConstants.endPointOfReadNotification}/$notificationId',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseModel = NotificationReadResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return responseModel.data;
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// PATCH /notification/read/all
  /// Marks all notifications as read
  Future<bool> markAllNotificationsAsRead() async {
    try {
      final response = await _dio.patch(
        ApiUrlConstants.endPointOfReadAllNotifications,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // 404 means nothing to mark → still a success scenario
      if (response.statusCode == 404) {
        return true;
      }

      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return true;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// DELETE /notification/all
  /// Deletes all notifications
  Future<bool> deleteAllNotifications() async {
    try {
      final response = await _dio.delete(
        ApiUrlConstants.endPointOfDeleteAllNotifications,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // 404 means nothing to delete → still treat as success
      if (response.statusCode == 404) {
        return true;
      }

      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return true;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// DELETE /notification/my
  /// Deletes current user's notifications
  Future<bool> deleteMyNotifications() async {
    try {
      final response = await _dio.delete(
        ApiUrlConstants.endPointOfMyNotifications,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // 404 means nothing to delete → still treat as success
      if (response.statusCode == 404) {
        return true;
      }

      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return true;
      }
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? 'Something went wrong.';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception(
            'No internet connection. Please check your network.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
}