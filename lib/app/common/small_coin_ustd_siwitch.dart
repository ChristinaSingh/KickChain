import 'package:flutter/material.dart';

class CoinUsdtSwitch extends StatefulWidget {
  const CoinUsdtSwitch({super.key});

  @override
  State<CoinUsdtSwitch> createState() => _CoinUsdtSwitchState();
}

class _CoinUsdtSwitchState extends State<CoinUsdtSwitch> {
  bool isUsdt = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isUsdt = !isUsdt;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 51,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: isUsdt
              ? const LinearGradient(
            colors: [
              Color(0xFF8AD9C6),
              Color(0xFF0F7B63),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
            colors: [
              Color(0xFFFFD54F),
              Color(0xFFFFA000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// TEXT
            Positioned(
              left: isUsdt ? 6 : null,
              right: isUsdt ? null : 6,
              child: Text(
                isUsdt ? "USDT" : "Coins",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// SLIDER CIRCLE
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment:
              isUsdt ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAEAEA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}