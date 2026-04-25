import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/auth_background.dart';
import '../../../common/colors.dart';
import '../../../common/glass_container.dart';
import '../../../common/text_styles.dart';
import '../controllers/o_t_p_v_e_r_i_f_i_c_a_t_i_o_n_screen_controller.dart';

class OTPVERIFICATIONScreenView
    extends GetView<OTPVERIFICATIONScreenController> {
  const OTPVERIFICATIONScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          children: [
            // Back
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
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
            const SizedBox(height: 40),

            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.15),
                border: Border.all(color: primaryColor, width: 2),
              ),
              child: const Icon(Icons.mark_email_read_rounded,
                  color: primaryColor, size: 40),
            ),
            const SizedBox(height: 24),

            Text('Verify Your Email', style: MyTextStyle.authTitle),
            const SizedBox(height: 8),
            Obx(() => Text(
              'Enter the 4-digit code sent to\n${controller.email.value}',
              textAlign: TextAlign.center,
              style: MyTextStyle.authSubtitle,
            )),
            const SizedBox(height: 36),

            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // OTP fields
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: controller.otpCtrl,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(14),
                      fieldHeight: 58,
                      fieldWidth: 58,
                      activeFillColor: primaryColor.withOpacity(0.15),
                      inactiveFillColor: inputFillColor,
                      selectedFillColor:
                      primaryColor.withOpacity(0.1),
                      activeColor: primaryColor,
                      inactiveColor: inputBorderColor,
                      selectedColor: primaryColor,
                      borderWidth: 1.5,
                    ),
                    enableActiveFill: true,
                    cursorColor: primaryColor,
                    onChanged: (_) {
                      controller.errorMsg.value = '';
                    },
                    onCompleted: (_) => controller.verifyOtp(),
                  ),
                  const SizedBox(height: 8),

                  // Error
                  Obx(() {
                    if (controller.errorMsg.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: errorRedColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: errorRedColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        controller.errorMsg.value,
                        textAlign: TextAlign.center,
                        style:
                        MyTextStyle.errorText.copyWith(fontSize: 13),
                      ),
                    );
                  }),

                  const SizedBox(height: 6),

                  // Verify button
                  Obx(() => GradientButton(
                    label: 'Verify OTP',
                    isLoading: controller.isLoading.value,
                    onTap: controller.verifyOtp,
                  )),

                  const SizedBox(height: 20),

                  // Resend OTP
                  Obx(() {
                    if (controller.resendTimer.value > 0) {
                      return Text(
                        'Resend OTP in ${controller.resendTimer.value}s',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                      );
                    }
                    return GestureDetector(
                      onTap: controller.isResending.value
                          ? null
                          : controller.resendOtp,
                      child: controller.isResending.value
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Resend OTP',
                        style: MyTextStyle.linkText.copyWith(
                            fontSize: 15),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}