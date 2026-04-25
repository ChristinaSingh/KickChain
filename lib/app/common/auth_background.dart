import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(child: child),
      ),
    );
  }
}