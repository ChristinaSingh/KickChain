// lib/data/apis/api_constants/api_url_constants.dart

class ApiUrlConstants {
  static const String baseUrl = 'https://node.aitechnotech.in/kickchain/api/v1';

  // Auth / User
  static const String endPointOfRegister = '/user/register';
  static const String endPointOfVerifyOtp = '/user/verify-otp';
  static const String endPointOfResendOtp = '/user/resend-otp';
  static const String endPointOfLogin = '/user/login';
  static const String endPointOfProfile = '/user/profile';
  static const String endPointOfUpdateProfile = '/user/profile';

  static const String endPointOfFaqs = '/user/faqs';
  static const String endPointOfPrivacyPolicy = '/user/privacy-policy';
  static const String endPointOfTermsAndConditions = '/user/privacy-policy';
  static const String endPointOfAllUsers = '/user/all';

  // Notification Settings
  static const String endPointOfNotificationSettings = '/notification/settings';

  // Notifications
  static const String endPointOfMyNotifications = '/notification/my';
  static const String endPointOfReadNotification = '/notification/read'; // + /:id
  static const String endPointOfReadAllNotifications = '/notification/read/all';
  static const String endPointOfDeleteAllNotifications = '/notification/all';

  // Friends
  static const String endPointOfSendFriendRequest = '/friend/send/request';
  static const String endPointOfFriendRequestStatus = '/friend/request/status';
  static const String endPointOfOutgoingFriendRequests = '/friend/outgoing/requests';
  static const String endPointOfIncomingFriendRequests = '/friend/incoming/requests';
  static const String endPointOfFriends = '/friend/friends';
  static const String endPointOfUnfriend = '/friend/unfriend';

  // Block
  static const String endPointOfBlockUser = '/block/block';
  static const String endPointOfUnblockUser = '/block/unblock';

  // Shop
  static const String endPointOfShopItems = '/shop/items';
  static const String endPointOfShopThemes = '$endPointOfShopItems/theme';
  static const String endPointOfShopBalls = '$endPointOfShopItems/ball';
  static const String endPointOfShopPucks = '$endPointOfShopItems/puck';
  static const String endPointOfShopCurrency = '$endPointOfShopItems/currency';
}