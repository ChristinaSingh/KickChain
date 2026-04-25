import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/auth_background.dart';
import '../../../common/colors.dart';
import '../../../common/glass_container.dart';
import '../../../common/text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/r_e_g_i_s_t_e_r_screen_controller.dart';

class REGISTERScreenView extends GetView<REGISTERScreenController> {
  const REGISTERScreenView({super.key});
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
            const SizedBox(height: 20),

            Text('Create Account', style: MyTextStyle.authTitle),
            const SizedBox(height: 6),
            Text(
              'Setup your profile to get started',
              style: MyTextStyle.authSubtitle,
            ),
            const SizedBox(height: 28),

            // Avatar picker
            Obx(() => GestureDetector(
              onTap: controller.pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: glassBg,
                    backgroundImage: controller.avatarFile.value != null
                        ? FileImage(controller.avatarFile.value!)
                        : null,
                    child: controller.avatarFile.value == null
                        ? const Icon(Icons.person_rounded,
                        size: 50, color: Colors.white38)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF053300), width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 6),
            Text(
              'Tap to add photo',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Form
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    GlassTextField(
                      controller: controller.nameCtrl,
                      label: 'Full Name',
                      hint: 'Enter your name',
                      prefixIcon: Icons.person_outline,
                      validator: controller.validateName,
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: controller.emailCtrl,
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: controller.phoneCtrl,
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: controller.validatePhone,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => GlassTextField(
                      controller: controller.passwordCtrl,
                      label: 'Password',
                      hint: 'Create a strong password',
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
                    const SizedBox(height: 18),

                    // Gender selector
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gender', style: MyTextStyle.inputLabel),
                        const SizedBox(height: 10),
                        Obx(() => Row(
                          children: [
                            _GenderChip(
                              label: 'Male',
                              icon: Icons.male_rounded,
                              selected:
                              controller.gender.value == 'male',
                              onTap: () =>
                                  controller.setGender('male'),
                            ),
                            const SizedBox(width: 12),
                            _GenderChip(
                              label: 'Female',
                              icon: Icons.female_rounded,
                              selected:
                              controller.gender.value == 'female',
                              onTap: () =>
                                  controller.setGender('female'),
                            ),
                            const SizedBox(width: 12),
                            _GenderChip(
                              label: 'Other',
                              icon: Icons.transgender_rounded,
                              selected:
                              controller.gender.value == 'other',
                              onTap: () =>
                                  controller.setGender('other'),
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Error
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

                    const SizedBox(height: 8),

                    Obx(() => GradientButton(
                      label: 'Create Account',
                      isLoading: controller.isLoading.value,
                      colors: const [shopStart, shopEnd],
                      onTap: controller.register,
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => Get.offNamed(Routes.L_O_G_I_N_SCREEN),
                  child: Text('Login', style: MyTextStyle.linkText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? primaryColor.withOpacity(0.25)
                : inputFillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primaryColor : inputBorderColor,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? primaryColor : Colors.white54,
                  size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? primaryColor : Colors.white54,
                  fontSize: 11,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
