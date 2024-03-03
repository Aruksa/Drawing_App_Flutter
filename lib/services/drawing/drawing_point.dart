import 'package:flutter/material.dart';

class DrawingPoint {
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPoint({
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 1.0,
  });
  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
      color: color,
      width: width,
      offsets: offsets ?? this.offsets,
    );
  }
}

class DrawingRectangle {
  Offset? centre;
  Offset? edge;
  Color color;
  double width;

  DrawingRectangle({
    this.centre,
    this.edge,
    this.color = Colors.black,
    this.width = 1.0,
  });

  void updateRadius(Offset bottomRightVertice) {
    edge = bottomRightVertice;
  }
}

class DrawingLine {
  Offset? start;
  Offset? end;
  Color color;
  double width;

  DrawingLine({
    this.start,
    this.end,
    this.width = 1.0,
    this.color = Colors.black,
  });

  void updateEnd(Offset newEnd) {
    end = newEnd;
  }
}

class DrawingCircle {
  Offset? centre;
  double radius;
  Color color;
  double width;

  DrawingCircle({
    this.centre,
    this.radius = 0,
    this.color = Colors.black,
    this.width = 1.0,
  });

  void updateRadius(double rad) {
    radius = rad;
  }
}
