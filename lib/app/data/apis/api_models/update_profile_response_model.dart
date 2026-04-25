class UpdateProfileResponseModel {
  final int? statusCode;
  final dynamic data;
  final String? message;
  final bool? success;

  UpdateProfileResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
      success: json['success'],
    );
  }
}