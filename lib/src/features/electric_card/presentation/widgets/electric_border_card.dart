import 'package:electric_border/src/core/constants.dart';
import 'package:flutter/material.dart';

import 'electric_border_painter.dart';

class ElectricBorderCard extends StatelessWidget {
  final AnimationController controller;

  const ElectricBorderCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ElectricBorderPainter(controller.value),
          child: Container(
            width: kCardWidth,
            height: kCardHeight,
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(kCardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kFeaturedPaddingHorizontal,
                      vertical: kFeaturedPaddingVertical),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    kFeatured,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: kFeaturedFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  kElectricCard,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kElectricCardFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  kDescription,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontSize: kDescriptionFontSize,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kLivePaddingHorizontal,
                          vertical: kLivePaddingVertical),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        kLive,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          fontSize: kLiveFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kVersionPaddingHorizontal,
                          vertical: kVersionPaddingVertical),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        kVersion,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          fontSize: kVersionFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
