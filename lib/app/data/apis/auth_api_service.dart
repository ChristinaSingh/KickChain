import 'dart:io';
import 'package:dio/dio.dart';

import 'api_constants/api_url_constants.dart';
import 'api_methods/dio_client.dart';
import 'api_models/login_response_model.dart';
import 'api_models/profile_response_model.dart';
import 'api_models/register_response_model.dart';


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
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'gender': gender,
        if (avatarFile != null)
          'avatar': await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        ApiUrlConstants.endPointOfRegister,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  RESEND OTP — PATCH
  // ══════════════════════════════════════════════════════════════════════════

  Future<RegisterResponseModel> resendOtp({
    required String email,
  }) async {
    try {
      final response = await _dio.patch(
        ApiUrlConstants.endPointOfResendOtp,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LOGIN — POST
  // ══════════════════════════════════════════════════════════════════════════

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiUrlConstants.endPointOfLogin,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  GET PROFILE — GET (auth token via interceptor)
  // ══════════════════════════════════════════════════════════════════════════

  Future<ProfileResponseModel> getProfile() async {
    try {
      final response = await _dio.get(ApiUrlConstants.endPointOfProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProfileResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  CENTRAL DIO ERROR HANDLER
  // ══════════════════════════════════════════════════════════════════════════

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