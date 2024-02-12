import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/line.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final List<Line> lines;
  final BuildContext context;

  DrawingPainter(
      {required this.points, required this.lines, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pointPaint = Paint()..color = Colors.black;
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mediaQueryData = MediaQuery.of(context);
    final screenSizeInPixels = mediaQueryData.size;
    final pixelDensity = mediaQueryData.devicePixelRatio;

    final screenSizeInInches = screenSizeInPixels / pixelDensity;
    final screenSizeInCentimeters = screenSizeInInches * 0.4;

    final screenWidthInCentimeters = screenSizeInCentimeters.width;
    final scale = screenWidthInCentimeters / screenSizeInPixels.width;

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
    }

    for (final line in lines) {
      final midPoint = Offset(
          (line.start.dx + line.end.dx) / 2, (line.start.dy + line.end.dy) / 2);
      final lengthInPixels = sqrt(pow(line.end.dx - line.start.dx, 2) +
          pow(line.end.dy - line.start.dy, 2));

      final lengthInCentimeters = lengthInPixels * scale;

      canvas.drawCircle(line.start, 3, pointPaint);
      canvas.drawCircle(line.end, 3, pointPaint);
      canvas.drawLine(line.start, line.end, linePaint);

      final span = TextSpan(
        style: const TextStyle(color: Colors.black),
        text: '${(lengthInCentimeters / 10).toStringAsFixed(1)} см',
      );
      final tp = TextPainter(
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
