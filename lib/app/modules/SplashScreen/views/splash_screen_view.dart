import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        controller.count.value;
        return SizedBox.expand(
          child: Image.asset(
            'assets/images/new_splash_screen_image.png',
            fit: BoxFit.cover, // fills the whole screen
          ),
        );
      }),
    );
  }
}
