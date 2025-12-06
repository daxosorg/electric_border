import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electric Card UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ElectricCardScreen(),
    );
  }
}

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
      duration:
          const Duration(seconds: 35), // Duration for one cycle of animation
    )..repeat(reverse: false); // Repeats animation
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
        ),
      ),
    );
  }
}

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
            width: 500, // Adjust width as needed
            height: 300, // Adjust height as needed
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // FEATURED tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white.withAlpha((255 * 0.8).round()),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Electric Card Title
                const Text(
                  'Electric Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Description
                Text(
                  'An electric border for shocking your users, the right way.',
                  style: TextStyle(
                    color: Colors.white.withAlpha((255 * 0.7).round()),
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white.withAlpha((255 * 0.8).round()),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'v1.0',
                        style: TextStyle(
                          color: Colors.white.withAlpha((255 * 0.8).round()),
                          fontSize: 12,
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

// Electric Border Painter
class ElectricBorderPainter extends CustomPainter {
  final double animationValue;
  final math.Random _rand = math.Random(); // Non-seeded for per-call randomness

  ElectricBorderPainter(this.animationValue);

  // Helper to create a jagged path based on an RRect and animation value
  Path _createJaggedPath(RRect rRect, double animationValue) {
    final Path jaggedPath = Path();
    final Path baseRRectPath = Path()..addRRect(rRect);
    final ui.PathMetrics pathMetrics = baseRRectPath.computeMetrics();

    // Use a secondary random for smoother, less "flickery" changes for some aspects
    // Seeded by animation for reproducible per-frame "randomness" in overall shape
    final math.Random pathRandom = math.Random((animationValue * 1000).toInt());

    for (final ui.PathMetric metric in pathMetrics) {
      bool firstPoint = true;
      // Variable step size for more uneven point distribution, leading to uneven curves
      for (double dist = 0;
          dist < metric.length;
          dist += 3.0 + pathRandom.nextDouble() * 5.0) {
        final ui.Tangent? tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          final Offset basePoint = tangent.position;
          final Offset rawNormal =
              Offset(-tangent.vector.dy, tangent.vector.dx);
          final Offset normal = rawNormal.distance == 0
              ? Offset.zero
              : rawNormal / rawNormal.distance;

          // Introduce more varied perturbation for "long and curvy" or "short and sharp" segments
          // Base perturbation oscillates with animation, modulated by random and position
          final double animationWave = math.sin(
              animationValue * 2 * math.pi * 5 +
                  dist / 50.0); // Wave along path + animation
          final double animationCosWave = math.cos(
              animationValue * 2 * math.pi * 5 +
                  dist / 30.0); // Another wave for complexity

          // Vary the magnitude of perturbation significantly for visual "thickness" variation
          final double perturbationMagnitude =
              (2.0 + pathRandom.nextDouble() * 5.0) *
                  (0.5 +
                      animationWave * 0.5 +
                      animationCosWave * 0.3); // Can be 0 to ~9 approx

          // Introduce a secondary, finer jitter using unseeded random for flickering effect
          final double jitter = (_rand.nextDouble() - 0.5) * 2 * 1.5;

          final Offset jaggedPoint =
              basePoint + normal * (perturbationMagnitude + jitter);

          if (firstPoint) {
            jaggedPath.moveTo(jaggedPoint.dx, jaggedPoint.dy);
            firstPoint = false;
          } else {
            jaggedPath.lineTo(jaggedPoint.dx, jaggedPoint.dy);
          }
        }
      }
      // Ensure the path closes to avoid gaps if `dist` doesn't exactly reach `metric.length`
      if (!firstPoint) {
        jaggedPath.close();
      }
    }
    return jaggedPath;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(20));

    // Colors for the lightning effect
    const Color outerGlowColor = Color(0xFF00BFFF); // Deep Sky Blue
    const Color midGlowColor = Color(0xFF87CEFA); // Light Sky Blue
    const Color innerGlowColor = Color(0xFFADD8E6); // Light Blue
    const Color coreColor = Colors.white;

    // Generate the base jagged path once per animation frame
    final Path animatedJaggedPath = _createJaggedPath(rRect, animationValue);

    // 1. Outer, most blurry glow (multiple layers for depth)
    for (int i = 0; i < 4; i++) {
      final Paint glowPaint = Paint()
        ..color = outerGlowColor.withAlpha((255 * (0.02 + i * 0.03)).round())
        ..style = PaintingStyle.stroke
        // Vary stroke width with randomness to create thick/thin effects
        ..strokeWidth = 25 + _rand.nextDouble() * 10 + i * 8
        // Vary blur amount with randomness
        ..maskFilter = ui.MaskFilter.blur(
            ui.BlurStyle.outer, 15 + _rand.nextDouble() * 5 + i * 7);

      // Shift the path slightly by a random amount for added unevenness and depth
      canvas.drawPath(
          animatedJaggedPath.shift(
              Offset(_rand.nextDouble() * 2 - 1, _rand.nextDouble() * 2 - 1)),
          glowPaint);
    }

    // 2. Mid-level glow (more opaque, less blur)
    for (int i = 0; i < 3; i++) {
      final Paint midPaint = Paint()
        ..color = midGlowColor.withAlpha((255 * (0.1 + i * 0.1)).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12 + _rand.nextDouble() * 6 + i * 4
        ..maskFilter = ui.MaskFilter.blur(
            ui.BlurStyle.normal, 6 + _rand.nextDouble() * 3 + i * 3);

      canvas.drawPath(
          animatedJaggedPath.shift(Offset(_rand.nextDouble() * 1.5 - 0.75,
              _rand.nextDouble() * 1.5 - 0.75)),
          midPaint);
    }

    // 3. Inner, brighter glow (even less blur)
    final Paint innerPaint = Paint()
      ..color = innerGlowColor.withAlpha((255 * 0.8).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 + _rand.nextDouble() * 3
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 3);
    canvas.drawPath(
        animatedJaggedPath.shift(
            Offset(_rand.nextDouble() * 1 - 0.5, _rand.nextDouble() * 1 - 0.5)),
        innerPaint);

    // 4. Core bright line (subtly jagged effect)
    final Paint corePaint = Paint()
      ..color = coreColor.withAlpha((255 * 0.9).round())
      ..style = PaintingStyle.stroke
      // Thinner for the core, with slight randomness
      ..strokeWidth = 2 + _rand.nextDouble() * 1.5;

    // Draw a few overlapping jagged paths to give depth and intensity to the core
    for (int k = 0; k < 2; k++) {
      canvas.drawPath(
          animatedJaggedPath.shift(Offset(_rand.nextDouble() * 0.5 - 0.25,
              _rand.nextDouble() * 0.5 - 0.25)),
          corePaint
            ..color = coreColor.withAlpha((255 * (0.5 + k * 0.2)).round()));
    }
  }

  @override
  bool shouldRepaint(covariant ElectricBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
