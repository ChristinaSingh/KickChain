// lib/data/apis/api_models/register_response_model.dart

class RegisterResponseModel {
  final int? statusCode;
  final dynamic data;
  final String? message;
  final bool? success;

  RegisterResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data,
      'message': message,
      'success': success,
    };
  }
}