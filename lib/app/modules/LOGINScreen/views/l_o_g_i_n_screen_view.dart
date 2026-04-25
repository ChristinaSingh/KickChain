import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/auth_background.dart';
import '../../../common/colors.dart';
import '../../../common/glass_container.dart';
import '../../../common/text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/l_o_g_i_n_screen_controller.dart';

class LOGINScreenView extends GetView<LOGINScreenController> {
  const LOGINScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          children: [
            // Back button
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.NAV_BAR_SCREEN);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: glassBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: glassBorder),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Logo
            const Icon(Icons.sports_soccer,
                size: 70, color: Colors.white),
            const SizedBox(height: 12),
            Text('Welcome Back!', style: MyTextStyle.authTitle),
            const SizedBox(height: 6),
            Text(
              'Login to continue your game',
              style: MyTextStyle.authSubtitle,
            ),
            const SizedBox(height: 36),

            // Form card
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    GlassTextField(
                      controller: controller.emailCtrl,
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),
                    const SizedBox(height: 18),
                    Obx(() => GlassTextField(
                      controller: controller.passwordCtrl,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: controller.obscurePass.value,
                      validator: controller.validatePassword,
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePassword,
                        child: Icon(
                          controller.obscurePass.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    )),
                    const SizedBox(height: 10),

                    // Error message
                    Obx(() {
                      if (controller.errorMsg.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: errorRedColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: errorRedColor.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: errorRedColor, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMsg.value,
                                style: MyTextStyle.errorText
                                    .copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // Login button
                    Obx(() => GradientButton(
                      label: 'Login',
                      isLoading: controller.isLoading.value,
                      onTap: controller.login,
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      color: Colors.white60, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => Get.offNamed(Routes.R_E_G_I_S_T_E_R_SCREEN),
                  child: Text(
                    'Create Account',
                    style: MyTextStyle.linkText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
