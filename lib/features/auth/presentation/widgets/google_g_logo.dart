import 'package:flutter/material.dart';

/// Compact multi-color "G" mark for social buttons (no asset).
class GoogleGLogo extends StatelessWidget {
  const GoogleGLogo({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final r = Rect.fromLTWH(0, 0, s, s);
    final stroke = s * 0.14;
    final paint = (Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      r.deflate(stroke * 0.6),
      -0.15 * 3.14159,
      1.85 * 3.14159,
      false,
      paint(const Color(0xFF4285F4)),
    );
    canvas.drawArc(
      r.deflate(stroke * 0.6),
      0.85 * 3.14159,
      0.95 * 3.14159,
      false,
      paint(const Color(0xFF34A853)),
    );
    canvas.drawArc(
      r.deflate(stroke * 0.6),
      1.75 * 3.14159,
      0.55 * 3.14159,
      false,
      paint(const Color(0xFFFBBC05)),
    );
    canvas.drawLine(
      Offset(s * 0.48, s * 0.48),
      Offset(s * 0.92, s * 0.48),
      paint(const Color(0xFF4285F4))..strokeWidth = stroke * 1.05,
    );
    canvas.drawArc(
      r.deflate(stroke * 0.6),
      -0.95 * 3.14159,
      0.45 * 3.14159,
      false,
      paint(const Color(0xFFEA4335)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
