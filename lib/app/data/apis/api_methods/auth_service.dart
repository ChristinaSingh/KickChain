// lib/data/apis/api_methods/auth_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../api_constants/api_url_constants.dart';
import '../api_models/login_response_model.dart';
import '../api_models/profile_response_model.dart';
import '../api_models/register_response_model.dart';
import '../api_models/update_profile_response_model.dart';
import '../dio_client/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // ══════════════════════════════════════════════════════════════════════════
  //  REGISTER — multipart/form-data POST
  // ══════════════════════════════════════════════════════════════════════════

  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String gender,
    File? avatarFile,
    Uint8List? avatarBytes,
    String? avatarFileName,
  }) async {
    try {
      dynamic avatarMultipart;
      if (avatarBytes != null && avatarBytes.isNotEmpty) {
        avatarMultipart = MultipartFile.fromBytes(
          avatarBytes,
          filename: (avatarFileName != null && avatarFileName.isNotEmpty)
              ? avatarFileName
              : 'avatar.jpg',
        );
      } else if (avatarFile != null) {
        avatarMultipart = await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        );
      }

      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'gender': gender,
        if (avatarMultipart != null) 'avatar': avatarMultipart,
      });

      final response = await _dio.post(
        ApiUrlConstants.endPointOfRegister,
        data: formData,
      );

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // ✅ Handle API error responses (400, 401, 422, 500, etc.)
      return _handleDioErrorForRegister(e);
    } catch (e) {
      return RegisterResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  VERIFY OTP — PATCH
  // ══════════════════════════════════════════════════════════════════════════

  Future<RegisterResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.patch(
        ApiUrlConstants.endPointOfVerifyOtp,
        data: {'email': email, 'otp': otp},
      );

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioErrorForRegister(e);
    } catch (e) {
      return RegisterResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  RESEND OTP — PATCH
  // ══════════════════════════════════════════════════════════════════════════

  Future<RegisterResponseModel> resendOtp({required String email}) async {
    try {
      final response = await _dio.patch(
        ApiUrlConstants.endPointOfResendOtp,
        data: {'email': email},
      );

      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioErrorForRegister(e);
    } catch (e) {
      return RegisterResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LOGIN — POST
  // ══════════════════════════════════════════════════════════════════════════

  Future<LoginResponseModel> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final data = <String, dynamic>{'email': email, 'password': password};
      if (fcmToken != null && fcmToken.trim().isNotEmpty) {
        data['fcmToken'] = fcmToken.trim();
      }

      final response = await _dio.post(
        ApiUrlConstants.endPointOfLogin,
        data: data,
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioErrorForLogin(e);
    } catch (e) {
      return LoginResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  GET PROFILE — GET (auth token via interceptor)
  // ══════════════════════════════════════════════════════════════════════════

  Future<ProfileResponseModel> getProfile() async {
    try {
      final response = await _dio.get(ApiUrlConstants.endPointOfProfile);

      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioErrorForProfile(e);
    } catch (e) {
      return ProfileResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  ERROR HANDLERS - Return Model Instead of Throwing Exception
  // ══════════════════════════════════════════════════════════════════════════

  RegisterResponseModel _handleDioErrorForRegister(DioException e) {
    final errorMessage = _extractErrorMessage(e);
    return RegisterResponseModel(
      success: false,
      message: errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  LoginResponseModel _handleDioErrorForLogin(DioException e) {
    final errorMessage = _extractErrorMessage(e);
    return LoginResponseModel(
      success: false,
      message: errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  ProfileResponseModel _handleDioErrorForProfile(DioException e) {
    final errorMessage = _extractErrorMessage(e);
    return ProfileResponseModel(
      success: false,
      message: errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  EXTRACT ERROR MESSAGE FROM DIO EXCEPTION
  // ══════════════════════════════════════════════════════════════════════════

  String _extractErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet and try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        return _parseApiErrorMessage(e.response);
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please try again.';
      case DioExceptionType.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<UpdateProfileResponseModel> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    File? avatarFile,
  }) async {
    try {
      final formMap = <String, dynamic>{};

      // send only non-null fields
      if (name != null) formMap['name'] = name;
      if (email != null) formMap['email'] = email;
      if (phoneNumber != null) formMap['phoneNumber'] = phoneNumber;
      if (gender != null) formMap['gender'] = gender;

      if (avatarFile != null) {
        formMap['avatar'] = await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.patch(
        ApiUrlConstants.endPointOfUpdateProfile,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return UpdateProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioErrorForUpdateProfile(e);
    } catch (e) {
      return UpdateProfileResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  UpdateProfileResponseModel _handleDioErrorForUpdateProfile(DioException e) {
    final errorMessage = _extractErrorMessage(e);
    return UpdateProfileResponseModel(
      success: false,
      message: errorMessage,
      statusCode: e.response?.statusCode,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PARSE API ERROR MESSAGE FROM RESPONSE
  // ══════════════════════════════════════════════════════════════════════════

  String _parseApiErrorMessage(Response? response) {
    if (response == null) return 'Unknown error occurred.';

    final statusCode = response.statusCode;
    final data = response.data;

    String? message;

    if (data is Map<String, dynamic>) {
      message =
          data['message'] ??
          data['error'] ??
          data['msg'] ??
          data['errors']?.toString();

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        } else if (firstError is String) {
          message = firstError;
        }
      }

      if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
        message = (data['errors'] as List).first.toString();
      }
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return message ?? 'Invalid request. Please check your input.';
      case 401:
        return message ?? 'Unauthorized. Please login again.';
      case 403:
        return message ?? 'Access denied. You don\'t have permission.';
      case 404:
        return message ?? 'Resource not found.';
      case 409:
        return message ?? 'Conflict. This resource already exists.';
      case 422:
        return message ?? 'Validation failed. Please check your input.';
      case 429:
        return message ?? 'Too many requests. Please wait and try again.';
      case 500:
        return message ?? 'Server error. Please try again later.';
      case 502:
        return message ?? 'Bad gateway. Please try again later.';
      case 503:
        return message ?? 'Service unavailable. Please try again later.';
      default:
        return message ?? 'Error $statusCode: Something went wrong.';
    }
  }
}
