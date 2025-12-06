import 'package:electric_border/src/core/constants.dart';
import 'package:flutter/material.dart';

import 'widgets/electric_border_card.dart';

class ElectricCardScreen extends StatefulWidget {
  const ElectricCardScreen({super.key});

  @override
  State<ElectricCardScreen> createState() => _ElectricCardScreenState();
}

class _ElectricCardScreenState extends State<ElectricCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kAnimationDuration,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
                  child: Padding(
            padding: const EdgeInsets.all(18),
            child: ElectricBorderCard(
              controller: _controller,
            ),
          ),      ),
    );
  }
}
