import 'dart:ui' as ui;
import 'package:drawing_app/services/drawing/drawing_painter.dart';
import 'package:drawing_app/services/drawing/drawing_point.dart';
import 'package:drawing_app/utilities/enums/stroke_shapes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // this widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DrawingPoint? currentDrawingPoint;
  DrawingCircle? currentDrawingCircle;
  DrawingRectangle? currentDrawingRectangle;
  DrawingLine? currentDrawingLine;

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];
  var drawingCircles = <DrawingCircle>[];
  var drawingRectangles = <DrawingRectangle>[];
  var drawingLines = <DrawingLine>[];

  var selectedColor = Colors.black;
  var strokeShape = StrokeEnums.curve;
  var strokeSize = 1.0;
  var strokeSizeInt = 1;


  GlobalKey globalKey = GlobalKey();

  Future<void> save() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: 'canvas_image'
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Container(
            color: Colors.grey[900],
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height:MediaQuery.of(context).size.height * 0.06,
                    child: IconButton(onPressed: () {
                      setState(() {
                        selectedColor = Colors.black;
                        strokeShape = StrokeEnums.curve;
                      });
                    }, icon: Image.asset('lib/assets/pen.png'))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: IconButton(onPressed: () {
                      setState(() {
                        selectedColor = Colors.white;
                        strokeShape = StrokeEnums.curve;
                      });
                    }, icon: Image.asset('lib/assets/eraser.png'))),

                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      child: Text(
                        "Size: $strokeSizeInt",
                        style: TextStyle(fontSize: 16, decoration: TextDecoration.none, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () {
                          setState(() {
                            if (strokeSize > 1.0) {
                              strokeSize = strokeSize - 1;
                              strokeSizeInt = strokeSize.toInt();
                            }


                          });
                        }, icon: Icon(Icons.remove), color: Colors.white,),
                        IconButton(onPressed: () {
                          setState(() {
                            if (strokeSize < 20) {
                              strokeSize = strokeSize + 1;
                              strokeSizeInt = strokeSize.toInt();
                            }
                          });
                        }, icon: Icon(Icons.add), color: Colors.white,),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  child: Text(
                    "Stroke\nType:",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, decoration: TextDecoration.none, color: Colors.white),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {
                      setState(() {
                        strokeShape = StrokeEnums.curve;
                      });
                    }, icon: Image.asset('lib/assets/curve.png'))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {
                      setState(() {
                        strokeShape = StrokeEnums.line;
                      });
                    }, icon: Image.asset('lib/assets/line.png'))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {
                      setState(() {
                        strokeShape = StrokeEnums.circle;
                      });
                    }, icon: Image.asset('lib/assets/circle.png'))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {
                      setState(() {

                        strokeShape = StrokeEnums.rectangle;

                      });

                    }, icon: Image.asset('lib/assets/square.png'))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {}, icon: Image.asset('lib/assets/triangle.png'))),
                Container(
                   width: MediaQuery.of(context).size.width * 0.035,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(color: Colors.grey[850]),
                    child: IconButton(onPressed: () {}, icon: Image.asset('lib/assets/triangle2.png')))
              ],
            ),

          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.grey,
                  height: 80,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Colors.blue, Colors.purple])
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                              setState(() {
                                drawingPoints.removeLast();
                              });
                            }
                          },
                          icon: const Icon(Icons.undo, color: Colors.white,),
                          label: const Text('Undo',style: TextStyle(color: Colors.white)),
                            ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Colors.blue, Colors.purple])
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if(drawingPoints.length < historyDrawingPoints.length) {

                                  final index = drawingPoints.length;
                                  drawingPoints.add(historyDrawingPoints[index]);
                                }
                              });
                            },
                            icon: const Icon(Icons.redo, color: Colors.white,),
                            label: const Text('Redo',style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Colors.blue, Colors.purple])
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                drawingPoints.clear();
                                drawingCircles.clear();
                                drawingRectangles.clear();
                                drawingLines.clear();
                              });
                            },
                            icon: const Icon(Icons.file_copy, color: Colors.white,),
                            label: const Text('Clear',style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Colors.blue, Colors.purple])
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.lock_open_outlined, color: Colors.white,),
                            label: const Text('Lock',style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [Colors.blue, Colors.purple])
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                save();
                              });
                            },
                            child: const Text("Download", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                ),
                             ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Scaffold(
                    floatingActionButton: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.black;
                            });
                          },
                            backgroundColor: Colors.black,
                            shape: CircleBorder(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.brown;
                            });
                          },
                            backgroundColor: Colors.brown,
                            shape: CircleBorder(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.red;
                            });
                          },
                            backgroundColor: Colors.red,
                            shape: CircleBorder(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.orange;
                            });
                          },
                            backgroundColor: Colors.orange,
                            shape: CircleBorder(),
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.yellow;
                            });
                          },
                            backgroundColor: Colors.yellow,
                            shape: CircleBorder(),
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.pinkAccent;
                            });
                          },
                            backgroundColor: Colors.pinkAccent,
                            shape: CircleBorder(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.blue;
                            });
                          },
                            backgroundColor: Colors.blue,
                            shape: CircleBorder(),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.green;
                            });
                          },
                            backgroundColor: Colors.green,
                            shape: CircleBorder(),
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: FloatingActionButton(onPressed: () {
                            setState(() {
                              selectedColor = Colors.purple;
                            });
                          },
                            backgroundColor: Colors.purple,
                            shape: CircleBorder(),
                          ),
                        ),
                ],
              ),
                    body: Container(
                        color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onPanStart: (details)  {
                              switch(strokeShape){

                                case StrokeEnums.line:
                                  setState(() {
                                    currentDrawingLine = DrawingLine(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      start: details.localPosition,
                                      end: details.localPosition,
                                      width: strokeSize,
                                      color: selectedColor,
                                    );

                                    if (currentDrawingLine == null) return;
                                    drawingLines.add(currentDrawingLine!);
                                  });


                                case StrokeEnums.circle:
                                  setState(() {
                                    currentDrawingCircle = DrawingCircle(
                                      id: DateTime.now().microsecondsSinceEpoch,
                                      centre: details.localPosition,
                                      color: selectedColor,
                                      width: strokeSize,
                                    );

                                    if (currentDrawingCircle == null) return;
                                    drawingCircles.add(currentDrawingCircle!);
                                  });

                                case StrokeEnums.rectangle:
                                  setState(() {
                                    currentDrawingRectangle = DrawingRectangle(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      centre: details.localPosition,
                                      edge: details.localPosition,
                                      color: selectedColor,
                                      width:  strokeSize,
                                    );
                                    if (currentDrawingRectangle == null) return;
                                    drawingRectangles.add(currentDrawingRectangle!);
                                  });

                                case StrokeEnums.curve:
                                // TODO: Handle this case.
                                default:
                                  setState(() {
                                    currentDrawingPoint = DrawingPoint(
                                      id: DateTime.now().microsecondsSinceEpoch,
                                      offsets: [
                                        details.localPosition,
                                      ],
                                      color: selectedColor,
                                      width: strokeSize,
                                    );

                                    if (currentDrawingPoint == null) return;
                                    drawingPoints.add(currentDrawingPoint!);
                                    historyDrawingPoints = List.of(drawingPoints);
                                  });

                              }

                            },
                            onPanUpdate: (details) {
                              switch(strokeShape) {

                                case StrokeEnums.line:
                                  setState(() {
                                    if (currentDrawingLine == null) return;
                                    Offset end = details.localPosition;
                                    currentDrawingLine?.updateEnd(end);
                                    drawingLines.last = currentDrawingLine!;
                                  });

                                case StrokeEnums.circle:
                                  setState(() {
                                    if (currentDrawingCircle == null) return;
                                    Offset? centre = currentDrawingCircle?.centre;
                                    Offset vector = details.localPosition;
                                    double rad = (centre! - vector).distance;
                                    currentDrawingCircle!.updateRadius(rad);
                                    drawingCircles.last = currentDrawingCircle!;
                                  });

                                case StrokeEnums.rectangle:
                                  setState(() {
                                    if (currentDrawingRectangle == null) return;
                                    Offset edge = details.localPosition;
                                    currentDrawingRectangle?.updateRadius(edge);
                                    drawingRectangles.last = currentDrawingRectangle!;
                                  });
                                case StrokeEnums.curve:
                                default:

                                setState(() {

                                  if (currentDrawingPoint == null) return;

                                  currentDrawingPoint = currentDrawingPoint?.copyWith(
                                    offsets: currentDrawingPoint!.offsets
                                      ..add(details.localPosition),
                                  );

                                  drawingPoints.last = currentDrawingPoint!;
                                  historyDrawingPoints = List.of(drawingPoints);


                                });


                              }

                            },
                            onPanEnd: (_) {
                              currentDrawingPoint = null;
                              currentDrawingCircle = null;
                              currentDrawingRectangle = null;
                              currentDrawingLine = null;
                            },
                            child: RepaintBoundary(
                              key: globalKey,
                              child: ClipRect(
                                child: CustomPaint(
                                  painter: DrawingPainter(
                                    drawingPoints: drawingPoints,
                                    drawingCircles: drawingCircles,
                                    drawingRectangles: drawingRectangles,
                                    drawingLines: drawingLines,
                                  ),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}





