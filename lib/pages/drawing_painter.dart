import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/line.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final List<Line> lines;

  DrawingPainter({required this.points, required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pointPaint = Paint()..color = Colors.black;
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }

    for (final line in lines) {
      final midPoint = Offset(
          (line.start.dx + line.end.dx) / 2, (line.start.dy + line.end.dy) / 2);
      final length = sqrt(pow(line.end.dx - line.start.dx, 2) +
          pow(line.end.dy - line.start.dy, 2));

      canvas.drawCircle(line.start, 3, pointPaint);
      canvas.drawCircle(line.end, 3, pointPaint);
      canvas.drawLine(line.start, line.end, linePaint);
      TextSpan span = TextSpan(
        style: const TextStyle(color: Colors.black),
        text: length.toStringAsFixed(2),
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, midPoint - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
