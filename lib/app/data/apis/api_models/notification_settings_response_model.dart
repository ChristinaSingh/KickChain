// lib/data/apis/api_models/notification_settings_response_model.dart


import '../api_methods/notification_settings_model.dart';

class NotificationSettingsResponseModel {
  final int? statusCode;
  final NotificationSettingsModel? data;
  final String? message;
  final bool? success;

  NotificationSettingsResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory NotificationSettingsResponseModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationSettingsResponseModel(
      statusCode: json['statusCode'],
      data: json['data'] != null
          ? NotificationSettingsModel.fromJson(json['data'])
          : null,
      message: json['message'],
      success: json['success'],
    );
  }
}