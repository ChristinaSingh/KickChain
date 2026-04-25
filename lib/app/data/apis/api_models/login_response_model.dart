import 'user_model.dart';

class LoginResponseModel {
  final int? statusCode;
  final LoginData? data;
  final String? message;
  final bool? success;

  LoginResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message']?.toString(),
      success: json['success'] as bool?,
    );
  }
}

class LoginData {
  final UserModel? user;
  final String? token;

  LoginData({this.user, this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token']?.toString(),
    );
  }
}