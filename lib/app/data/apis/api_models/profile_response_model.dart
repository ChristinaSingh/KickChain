import 'user_model.dart';

class ProfileResponseModel {
  final int? statusCode;
  final UserModel? data;
  final String? message;
  final bool? success;

  ProfileResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message']?.toString(),
      success: json['success'] as bool?,
    );
  }
}