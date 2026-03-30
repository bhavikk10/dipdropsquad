import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Soft layered waves for the welcome screen (light grey / white).
class WavyWelcomeBackground extends StatelessWidget {
  const WavyWelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: const _WavyWelcomePainter(),
        );
      },
    );
  }
}

class _WavyWelcomePainter extends CustomPainter {
  const _WavyWelcomePainter();

  static const _base = Color(0xFFF0F0F2);
  static const _layer1 = Color(0xFFE6E8EC);
  static const _layer2 = Color(0xFFDEDFE5);
  static const _highlight = Color(0xFFFAFAFB);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = _highlight);

    void waveLayer(Color color, double yFactor, double amp, double phase) {
      final path = Path()..moveTo(0, size.height * 0.35);
      final segments = 6;
      for (var i = 0; i <= segments; i++) {
        final t = i / segments;
        final x = size.width * t;
        final y = size.height * yFactor +
            amp * (0.5 + 0.5 * math.sin(t * 6.28318 + phase));
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }

    waveLayer(_layer2, 0.42, 28, 0.2);
    waveLayer(_layer1, 0.48, 22, 1.1);
    waveLayer(_base, 0.55, 18, 2.0);

    final soft = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.85, size.height * 0.12),
        width: size.width * 0.9,
        height: size.height * 0.35,
      ));
    canvas.drawPath(
      soft,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
