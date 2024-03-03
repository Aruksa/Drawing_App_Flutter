import 'package:flutter/material.dart';
class DrawingPoint {
  int id;
  List<Offset> offsets;
  Color color;
  double width;

DrawingPoint({
  this.id = -1,
  this.offsets = const [],
  this.color = Colors.black,
  this.width = 2,

});
DrawingPoint copyWith({List<Offset>? offsets}) {
  return DrawingPoint(
    id: id,
    color: color,
    width: width,
    offsets: offsets ?? this.offsets,
  );
 }

}

class DrawingRectangle{
  int id;
  Offset? centre;
  Offset? edge;
  Color color;
  double width;

  DrawingRectangle({
    this.id = -1,
    this.centre,
    this.edge,
    this.color = Colors.black,
    this.width = 2.0,

});

  void updateRadius(Offset bottomVertixR) {
    edge = bottomVertixR;
  }
}

class DrawingLine{
  int id;
  Offset? start;
  Offset? end;
  Color color;
  double width;

  DrawingLine({
    this.id = -1,
    this.start,
    this.end,
    this.width = 2.0,
    this.color = Colors.black,
 });

  void updateEnd(Offset newEnd) {
    end = newEnd;
  }
}

class DrawingCircle{

  int id;
  Offset? centre;
  double radius;
  Color color;
  double width;

  DrawingCircle({
  this.id = -1,
  this.centre,
  this.radius = 0,
  this.color = Colors.black,
  this.width = 2.0,
});

  void updateRadius(double rad) {
    radius = rad;
  }
}






