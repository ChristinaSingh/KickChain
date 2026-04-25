import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../controllers/privacy_p_olicy_controller.dart';

class PrivacyPOlicyView extends GetView<PrivacyPOlicyController> {
  const PrivacyPOlicyView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PrivacyPOlicyController>()) {
      Get.put(PrivacyPOlicyController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── Background ─────────────────────────
          const _Background(),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────
                _Header(onBack: () => Get.back()),

                // ── Scrollable content ───────────
                Expanded(
                  child: Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      final data = controller.policyData.value;
                      if (data == null) {
                        return const Center(
                          child: Text(
                            'No Privacy Policy found.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(22, 28, 22, 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.headingOne != null)
                              _PolicySection(
                                title: data.headingOne!,
                                content: data.descriptionOne ?? '',
                              ),
                            if (data.headingTwo != null)
                              _PolicySection(
                                title: data.headingTwo!,
                                content: data.descriptionTwo ?? '',
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BACKGROUND
// ─────────────────────────────────────────────

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.3, -0.7),
          radius: 1.3,
          colors: [
            Color(0xFF1DB800),
            Color(0xFF0A6400),
            Color(0xFF053300),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER  (back button + title)
// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Glassmorphic back button — same as every other screen
          GestureDetector(
            onTap: onBack,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backButtonColor.withOpacity(0.85),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TERMS SECTION
//  Each section = bold heading + body paragraphs
// ─────────────────────────────────────────────

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;
  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section heading ────────────────────
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),

          // ── Content ────────────────────────────
          Text(
            content,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              height: 1.65,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}