import 'package:drawing_app/services/drawing/drawing_point.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter{
  final List<DrawingPoint> drawingPoints;
  final List<DrawingCircle> drawingCircles;
  final List<DrawingRectangle> drawingRectangles;
  final List<DrawingLine> drawingLines;

  DrawingPainter({ required this.drawingLines, required this.drawingRectangles, required this.drawingCircles, required this.drawingPoints});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawPaint(paint);

    for (var drawingLine in drawingLines) {
      final paintLine = Paint();
      paintLine.color = drawingLine.color;
      paintLine.isAntiAlias = true;
      paintLine.strokeWidth = drawingLine.width;
      paintLine.strokeCap = StrokeCap.round;
      canvas.drawLine(drawingLine.start!, drawingLine.end!, paintLine);

    }

    for (var drawingRectangle in drawingRectangles) {
      final paintRectangle = Paint()
      ..color = drawingRectangle.color
      ..isAntiAlias = true
      ..strokeWidth = drawingRectangle.width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

      Rect rectangle = Rect.fromPoints(drawingRectangle.centre!, drawingRectangle.edge!);
      canvas.drawRect(rectangle, paintRectangle);

    }
    for (var drawingCircle in drawingCircles) {
      final paintCircle = Paint();
      paintCircle.color = drawingCircle.color;
      paintCircle.isAntiAlias = true;
      paintCircle.strokeWidth = drawingCircle.width;
      paintCircle.strokeCap = StrokeCap.round;
      paintCircle.style = PaintingStyle.stroke;

      canvas.drawCircle(drawingCircle.centre!, drawingCircle.radius, paintCircle);

    }

    for(var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;


      for(var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length -1;
        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i+1];
          canvas.drawLine(current, next, paint);
        } else {

        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}