// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../common/http_methods.dart';
// import '../api_constants/api_key_constants.dart';
// import '../api_models/add_contact_msg_model.dart';
// import '../api_models/get_create_password_model.dart';
// import '../api_models/get_email_verify_model.dart';
// import '../api_models/get_faq_model.dart';
// import '../api_models/get_password_resst_model.dart';
// import '../api_models/get_profile_model.dart';
// import '../api_models/login_model.dart';
// import '../api_models/notifiucationGetModel.dart';
// import '../api_models/register_model.dart';
// import 'package:http/http.dart' as http;
// import '../api_constants/api_url_constants.dart';
//
// class ApiMethods {
//   static Future<RegisterModel?> register({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfUserSignup,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return RegisterModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<EmailVerifyModel?> verifyEmailOtp({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfOtpVerify,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return EmailVerifyModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<EmailVerifyModel?> resendEmailOtp({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfOtpResend,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return EmailVerifyModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<LoginModel?> loginApi({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfLogin,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return LoginModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<GetProfileModel?> getProfile({
//     void Function(int)? checkResponse,
//     Map<String, dynamic>? bodyParams,
//   }) async {
//     GetProfileModel? userModel;
//     http.Response? response = await MyHttp.getMethod(
//       url: ApiUrlConstants.endPointOfGetProfile,
//       checkResponse: checkResponse,
//     );
//     if (response != null) {
//       userModel = GetProfileModel.fromJson(jsonDecode(response.body));
//       return userModel;
//     }
//     return null;
//   }
//
//   static Future<PassWordResetModel?> passwordReset({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfForgotPassword,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return PassWordResetModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<CreatePasswordModel?> createNewPassword({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfCreateNewPassword,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return CreatePasswordModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<http.StreamedResponse?> uploadProfilePhoto({
//     required String name,
//     required String phoneNumber,
//     required File imageFile,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(ApiKeyConstants.token);
//
//     final uri = Uri.parse(ApiUrlConstants.endPointOfUpdateProfile);
//
//     final request = http.MultipartRequest('POST', uri)
//       ..fields['name'] = name
//       ..fields['phoneNumber'] = phoneNumber
//       ..headers['Accept'] = 'application/json';
//
//     // Add authorization token if available
//     if (token != null && token.isNotEmpty) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }
//
//     // Attach file (binary)
//     request.files.add(
//       await http.MultipartFile.fromPath('avatar', imageFile.path),
//     );
//
//     // Send the request
//     final response = await request.send();
//
//     // Log for debugging
//     if (kDebugMode) {
//       print('UPLOAD STATUS CODE: ${response.statusCode}');
//     }
//
//     return response;
//   }
//
//   static Future<AddContactMsgModel?> addContactMsgApi({
//     required dynamic bodyParams,
//     required BuildContext context,
//   }) async {
//     http.Response? response = await MyHttp.postMethod(
//       bodyParams: bodyParams,
//       url: ApiUrlConstants.endPointOfAddContactMsg,
//       wantSnackBar: false,
//     );
//
//     if (response != null) {
//       return AddContactMsgModel.fromJson(jsonDecode(response.body));
//     }
//     return null;
//   }
//
//   static Future<FaqModel?> getFaq({
//     void Function(int)? checkResponse,
//     Map<String, dynamic>? bodyParams,
//   }) async {
//     FaqModel? userModel;
//     http.Response? response = await MyHttp.getMethod(
//       url: ApiUrlConstants.endPointOfGetFaq,
//       checkResponse: checkResponse,
//     );
//     if (response != null) {
//       userModel = FaqModel.fromJson(jsonDecode(response.body));
//       return userModel;
//     }
//     return null;
//   }
//
//   static Future<NotificationsGetModel?> getNotificationOnOffSwitch({
//     void Function(int)? checkResponse,
//     Map<String, dynamic>? bodyParams,
//   }) async {
//     NotificationsGetModel? userModel;
//     http.Response? response = await MyHttp.getMethod(
//       url: ApiUrlConstants.endPointOfNotificationsSwitch,
//       checkResponse: checkResponse,
//     );
//     if (response != null) {
//       userModel = NotificationsGetModel.fromJson(jsonDecode(response.body));
//       return userModel;
//     }
//     return null;
//   }
// }
