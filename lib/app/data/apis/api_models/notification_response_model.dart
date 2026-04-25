// lib/data/apis/api_models/notification_response_model.dart

import 'notification_model.dart';

/// Response model for GET /notification/my
class NotificationListResponseModel {
  final int statusCode;
  final List<NotificationModel> data;
  final String message;
  final bool success;

  const NotificationListResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<NotificationModel> notifications = [];

    if (rawData is List) {
      notifications = rawData
          .whereType<Map<String, dynamic>>()
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    return NotificationListResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      data: notifications,
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }
}

/// Response model for PATCH /notification/read/:id
class NotificationReadResponseModel {
  final int statusCode;
  final NotificationModel? data;
  final String message;
  final bool success;

  const NotificationReadResponseModel({
    required this.statusCode,
    this.data,
    required this.message,
    required this.success,
  });

  factory NotificationReadResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    NotificationModel? notification;

    if (rawData is Map<String, dynamic> && rawData.isNotEmpty) {
      notification = NotificationModel.fromJson(rawData);
    }

    return NotificationReadResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      data: notification,
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }
}

/// Response model for PATCH /notification/read/all & DELETE endpoints
class NotificationSimpleResponseModel {
  final int statusCode;
  final String message;
  final bool success;

  const NotificationSimpleResponseModel({
    required this.statusCode,
    required this.message,
    required this.success,
  });

  factory NotificationSimpleResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationSimpleResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }
}