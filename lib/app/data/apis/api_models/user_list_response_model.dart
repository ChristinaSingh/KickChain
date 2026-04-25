// lib/data/apis/api_models/user_list_response_model.dart

class UserListResponseModel {
  final int? statusCode;
  final List<UserData>? data;
  final String? message;
  final bool? success;

  UserListResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) {
    return UserListResponseModel(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class UserData {
  final String? id; // mapped from _id
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? avatar;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: (json['_id'] ?? json['id']) as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}