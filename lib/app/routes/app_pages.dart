import 'package:get/get.dart';

import '../modules/DailyMissionsScreen/bindings/daily_missions_screen_binding.dart';
import '../modules/DailyMissionsScreen/views/daily_missions_screen_view.dart';
import '../modules/DepositScreen/bindings/deposit_screen_binding.dart';
import '../modules/DepositScreen/views/deposit_screen_view.dart';
import '../modules/FaqScreen/bindings/faq_screen_binding.dart';
import '../modules/FaqScreen/views/faq_screen_view.dart';
import '../modules/InviteFriendsScreen/bindings/invite_friends_screen_binding.dart';
import '../modules/InviteFriendsScreen/views/invite_friends_screen_view.dart';
import '../modules/LOGINScreen/bindings/l_o_g_i_n_screen_binding.dart';
import '../modules/LOGINScreen/views/l_o_g_i_n_screen_view.dart';
import '../modules/MatchSetupScreen/bindings/match_setup_screen_binding.dart';
import '../modules/MatchSetupScreen/views/match_setup_screen_view.dart';
import '../modules/NavBarScreen/bindings/nav_bar_screen_binding.dart';
import '../modules/NavBarScreen/views/nav_bar_screen_view.dart';
import '../modules/NotificationSCreen/bindings/notification_s_creen_binding.dart';
import '../modules/NotificationSCreen/views/notification_s_creen_view.dart';
import '../modules/OTPVERIFICATIONScreen/bindings/o_t_p_v_e_r_i_f_i_c_a_t_i_o_n_screen_binding.dart';
import '../modules/OTPVERIFICATIONScreen/views/o_t_p_v_e_r_i_f_i_c_a_t_i_o_n_screen_view.dart';
import '../modules/ProfileSCreen/bindings/profile_s_creen_binding.dart';
import '../modules/ProfileSCreen/views/profile_s_creen_view.dart';
import '../modules/REGISTERScreen/bindings/r_e_g_i_s_t_e_r_screen_binding.dart';
import '../modules/REGISTERScreen/views/r_e_g_i_s_t_e_r_screen_view.dart';
import '../modules/SettingNotification/bindings/setting_notification_binding.dart';
import '../modules/SettingNotification/views/setting_notification_view.dart';
import '../modules/SettingScren/bindings/setting_scren_binding.dart';
import '../modules/SettingScren/views/setting_scren_view.dart';
import '../modules/ShopScreen/bindings/shop_screen_binding.dart';
import '../modules/ShopScreen/views/shop_screen_view.dart';
import '../modules/SplashScreen/bindings/splash_screen_binding.dart';
import '../modules/SplashScreen/views/splash_screen_view.dart';
import '../modules/WalletScreen/bindings/wallet_screen_binding.dart';
import '../modules/WalletScreen/views/wallet_screen_view.dart';
import '../modules/WithdrawScreen/bindings/withdraw_screen_binding.dart';
import '../modules/WithdrawScreen/views/withdraw_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/leaderBoardScreen/bindings/leader_board_screen_binding.dart';
import '../modules/leaderBoardScreen/views/leader_board_screen_view.dart';
import '../modules/privacyPOlicy/bindings/privacy_p_olicy_binding.dart';
import '../modules/privacyPOlicy/views/privacy_p_olicy_view.dart';
import '../modules/profile_screen/bindings/profile_screen_binding.dart';
import '../modules/profile_screen/views/profile_screen_view.dart'
    hide ProfileScreenView;
import '../modules/termsConditions/bindings/terms_conditions_binding.dart';
import '../modules/termsConditions/views/terms_conditions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.NAV_BAR_SCREEN,
      page: () => const NavBarScreenView(),
      binding: NavBarScreenBinding(),
    ),
    GetPage(
      name: _Paths.INVITE_FRIENDS_SCREEN,
      page: () => const InviteFriendsScreenView(),
      binding: InviteFriendsScreenBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_SCREEN,
      page: () => const WalletScreenView(),
      binding: WalletScreenBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_SCREN,
      page: () => const SettingsScreen(),
      binding: SettingScrenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_S_CREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileSCreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_S_CREEN,
      page: () => const NotificationsScreen(),
      binding: NotificationSCreenBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_NOTIFICATION,
      page: () => const NotificationSettingsScreen(),
      binding: SettingNotificationBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_SCREEN,
      page: () => const ShopScreen(),
      binding: ShopScreenBinding(),
    ),
    GetPage(
      name: _Paths.MATCH_SETUP_SCREEN,
      page: () => const MatchSetupScreen(),
      binding: MatchSetupScreenBinding(),
    ),
    GetPage(
      name: _Paths.DEPOSIT_SCREEN,
      page: () => const DepositScreen(),
      binding: DepositScreenBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW_SCREEN,
      page: () => const WithdrawScreen(),
      binding: WithdrawScreenBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_CONDITIONS,
      page: () => const TermsOfServiceScreen(),
      binding: TermsConditionsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_P_OLICY,
      page: () => const PrivacyPOlicyView(),
      binding: PrivacyPOlicyBinding(),
    ),
    GetPage(
      name: _Paths.FAQ_SCREEN,
      page: () => const FaqScreen(),
      binding: FaqScreenBinding(),
    ),
    GetPage(
      name: _Paths.LEADER_BOARD_SCREEN,
      page: () => const LeaderboardScreen(),
      binding: LeaderBoardScreenBinding(),
    ),
    GetPage(
      name: _Paths.DAILY_MISSIONS_SCREEN,
      page: () => const DailyMissionsScreen(),
      binding: DailyMissionsScreenBinding(),
    ),
    GetPage(
      name: _Paths.R_E_G_I_S_T_E_R_SCREEN,
      page: () => const REGISTERScreenView(),
      binding: REGISTERScreenBinding(),
    ),
    GetPage(
      name: _Paths.L_O_G_I_N_SCREEN,
      page: () => const LOGINScreenView(),
      binding: LOGINScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView2(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.O_T_P_V_E_R_I_F_I_C_A_T_I_O_N_SCREEN,
      page: () => const OTPVERIFICATIONScreenView(),
      binding: OTPVERIFICATIONScreenBinding(),
    ),
  ];
}
