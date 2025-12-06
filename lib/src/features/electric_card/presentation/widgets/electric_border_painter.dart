import 'package:electric_border/src/core/constants.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ElectricBorderPainter extends CustomPainter {
  final double animationValue;
  final math.Random _rand = math.Random();

  ElectricBorderPainter(this.animationValue);

  Path _createJaggedPath(RRect rRect, double animationValue) {
    final Path jaggedPath = Path();
    final Path baseRRectPath = Path()..addRRect(rRect);
    final ui.PathMetrics pathMetrics = baseRRectPath.computeMetrics();

    final math.Random pathRandom = math.Random((animationValue * 1000).toInt());

    for (final ui.PathMetric metric in pathMetrics) {
      bool firstPoint = true;
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

          final double animationWave =
              math.sin(animationValue * 2 * math.pi * 5 + dist / 50.0);
          final double animationCosWave =
              math.cos(animationValue * 2 * math.pi * 5 + dist / 30.0);

          final double perturbationMagnitude =
              (2.0 + pathRandom.nextDouble() * 5.0) *
                  (0.5 + animationWave * 0.5 + animationCosWave * 0.3);

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
        RRect.fromRectAndRadius(rect, const Radius.circular(kBorderRadius));

    const Color outerGlowColor = kOuterGlowColor;
    const Color midGlowColor = kMidGlowColor;
    const Color innerGlowColor = kInnerGlowColor;
    const Color coreColor = kCoreColor;

    final Path animatedJaggedPath = _createJaggedPath(rRect, animationValue);

    for (int i = 0; i < 4; i++) {
      final Paint glowPaint = Paint()
        ..color = outerGlowColor.withAlpha((255 * (0.02 + i * 0.03)).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25 + _rand.nextDouble() * 10 + i * 8
        ..maskFilter = ui.MaskFilter.blur(
            ui.BlurStyle.outer, 15 + _rand.nextDouble() * 5 + i * 7);

      canvas.drawPath(
          animatedJaggedPath.shift(
              Offset(_rand.nextDouble() * 2 - 1, _rand.nextDouble() * 2 - 1)),
          glowPaint);
    }

    for (int i = 0; i < 3; i++) {
      final Paint midPaint = Paint()
        ..color = midGlowColor.withAlpha((255 * (0.1 + i * 0.1)).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12 + _rand.nextDouble() * 6 + i * 4
        ..maskFilter = ui.MaskFilter.blur(
            ui.BlurStyle.normal, 6 + _rand.nextDouble() * 3 + i * 3);

      canvas.drawPath(
          animatedJaggedPath.shift(Offset(
              _rand.nextDouble() * 1.5 - 0.75, _rand.nextDouble() * 1.5 - 0.75)),
          midPaint);
    }

    final Paint innerPaint = Paint()
      ..color = innerGlowColor.withAlpha((255 * 0.8).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 + _rand.nextDouble() * 3
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 3);
    canvas.drawPath(
        animatedJaggedPath.shift(
            Offset(_rand.nextDouble() * 1 - 0.5, _rand.nextDouble() * 1 - 0.5)),
        innerPaint);

    final Paint corePaint = Paint()
      ..color = coreColor.withAlpha((255 * 0.9).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 + _rand.nextDouble() * 1.5;

    for (int k = 0; k < 2; k++) {
      canvas.drawPath(
          animatedJaggedPath.shift(Offset(
              _rand.nextDouble() * 0.5 - 0.25, _rand.nextDouble() * 0.5 - 0.25)),
          corePaint
            ..color = coreColor.withAlpha((255 * (0.5 + k * 0.2)).round()));
    }
  }

  @override
  bool shouldRepaint(covariant ElectricBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
