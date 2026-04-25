// lib/data/apis/api_methods/notification_settings_service.dart

import 'package:dio/dio.dart';
import '../api_constants/api_url_constants.dart';
import '../api_models/notification_settings_response_model.dart';
import 'dio_client.dart';
import 'notification_settings_model.dart';

class NotificationSettingsService {
  final Dio _dio = DioClient().dio;

  /// GET /notification/settings
  Future<NotificationSettingsModel> getNotificationSettings() async {
    try {
      final response = await _dio.get(
        ApiUrlConstants.endPointOfNotificationSettings,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseModel = NotificationSettingsResponseModel.fromJson(
          response.data,
        );
        if (responseModel.data != null) {
          return responseModel.data!;
        }
        throw Exception('No data received from server.');
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// PUT /notification/settings
  Future<NotificationSettingsModel> updateNotificationSettings({
    required bool matchInvites,
    required bool matchResults,
    required bool payouts,
    required bool referralRewards,
    required bool systemUpdates,
  }) async {
    try {
      final response = await _dio.put(
        ApiUrlConstants.endPointOfNotificationSettings,
        data: {
          'matchInvites': matchInvites,
          'matchResults': matchResults,
          'payouts': payouts,
          'referralRewards': referralRewards,
          'systemUpdates': systemUpdates,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseModel = NotificationSettingsResponseModel.fromJson(
          response.data,
        );
        if (responseModel.data != null) {
          return responseModel.data!;
        }
        throw Exception('No data received from server.');
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
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
        final message = e.response?.data?['message'] ?? 'Something went wrong.';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
}
