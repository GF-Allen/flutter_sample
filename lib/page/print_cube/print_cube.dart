import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'vertex.dart';

class Cube extends StatefulWidget {
  const Cube({super.key});

  @override
  _CubeState createState() => _CubeState();
}

class _CubeState extends State<Cube> with TickerProviderStateMixin {
  double angleX = 0.0;
  double angleY = 0.0;
  double angleZ = 0.0;
  Color color = Colors.blue;
  bool mode = false;

  double size = 200.0;

  void onChangeSize(double s) {
    setState(() {
      size = s;
    });
  }

  Future<dynamic> _setColor() async {
    setState(() {
      color = Color.fromARGB(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
    });
  }

  void _getColor(bool x) {
    setState(() {
      mode = x;
    });
  }

  double _previousX = 0.0;
  double _previousY = 0.0;

  void _updateCube(DragUpdateDetails data) {
    if (angleY > 360.0) {
      angleY = angleY - 360.0;
    }
    if (_previousY > data.globalPosition.dx) {
      setState(() {
        angleY = angleY - 1;
      });
    }
    if (_previousY < data.globalPosition.dx) {
      setState(() {
        angleY = angleY + 1;
      });
    }
    _previousY = data.globalPosition.dx;

    if (angleX > 360.0) {
      angleX = angleX - 360.0;
    }
    if (_previousX > data.globalPosition.dy) {
      setState(() {
        angleX = angleX - 1;
      });
    }
    if (_previousX < data.globalPosition.dy) {
      setState(() {
        angleX = angleX + 1;
      });
    }
    _previousX = data.globalPosition.dy;
  }

  void _accelerateCube(DragEndDetails data) {
    //debugPrint(((data.velocity.pixelsPerSecond.dx.abs()/(2*3.14*100.0))*180).toString());
  }

  void _updateY(DragUpdateDetails data) {
    _updateCube(data);
  }

  void _updateX(DragUpdateDetails data) {
    _updateCube(data);
  }

  void _onDragEndX(DragEndDetails data) {
    _accelerateCube(data);
  }

  void _onDragEndY(DragEndDetails data) {
    _accelerateCube(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: _updateY,
            onVerticalDragUpdate: _updateX,
            onVerticalDragEnd: _onDragEndX,
            onHorizontalDragEnd: _onDragEndY,
            child: CustomPaint(
              painter: CubePainter(mode, color, angleX, angleY, angleZ, size),
              size: const Size(200.0, 200.0),
            ),
          ),
        ),
        const Divider(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                "Wire",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(value: mode, onChanged: _getColor),
              const Text(
                "Solid",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: _setColor,
                  child: const Text(
                    "Select Color",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
                alignment: FractionalOffset.centerLeft,
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: const Text(
                  "Size:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Slider(
                value: size,
                min: 50.0,
                max: 300.0,
                onChanged: onChangeSize,
                label: "Size",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CubePainter extends CustomPainter {
  CubePainter(this.mode, this._color, this.angleX, this.angleY, this.angleZ, this.fov);

  final _vertices = [
    [-1.0, 1.0, -1.0],
    [1.0, 1.0, -1.0],
    [1.0, -1.0, -1.0],
    [-1.0, -1.0, -1.0],
    [-1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, -1.0, 1.0],
    [-1.0, -1.0, 1.0]
  ];
  var faces = [
    [0, 1, 2, 3],
    [1, 5, 6, 2],
    [5, 4, 7, 6],
    [4, 0, 3, 7],
    [0, 4, 5, 1],
    [3, 2, 6, 7]
  ];
  List colors = <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.black];
  Color _color;

  bool mode;

  double angleX;
  double angleY;
  double angleZ;
  double fov;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint x = Paint();
    x.strokeWidth = 5.0;
    x.color = _color;
    List<Vertex> vertices = <Vertex>[];
    _vertices.forEach((e) {
      final Vertex x = Vertex(e[0], e[1], e[2]);
      final Vertex n = x.rotateX(angleX).rotateY(angleY).rotateZ(angleZ).convert2D(fov, 3.0);
      vertices.add(n);
    });
    final List<Map> avgOfZ = <Map>[];
    for (int i = 0; i < faces.length; i++) {
      var face = faces[i];
      Map data = <String, dynamic>{"index": i, "z": (vertices[face[0]].z + vertices[face[1]].z + vertices[face[2]].z + vertices[face[3]].z)};
      avgOfZ.add(data);
    }
    avgOfZ.sort((Map a, Map b) => (b['z'] - a['z']).round());
    final Vertex center = Vertex(size.width / 2, size.height / 2, 0.0);
    for (int i = 0; i < faces.length; i++) {
      if (mode) {
        x.color = colors[avgOfZ[i]['index']];
        x.strokeWidth = 5.0;
        x.style = PaintingStyle.fill;
        var e = faces[avgOfZ[i]['index']];
        List<Offset> f = <Offset>[];
        f.add(Offset(vertices[e[0]].x + center.x, vertices[e[0]].y + center.y));
        f.add(Offset(vertices[e[1]].x + center.x, vertices[e[1]].y + center.y));
        f.add(Offset(vertices[e[2]].x + center.x, vertices[e[2]].y + center.y));
        f.add(Offset(vertices[e[3]].x + center.x, vertices[e[3]].y + center.y));
        Path draw = Path();
        draw.addPolygon(f, false);
        canvas.drawPath(draw, x);
      } else {
        var e = faces[avgOfZ[i]['index']];
        canvas.drawCircle(Offset(vertices[e[0]].x + center.x, vertices[e[0]].y + center.y), 5.0, x);
        canvas.drawCircle(Offset(vertices[e[1]].x + center.x, vertices[e[1]].y + center.y), 5.0, x);
        canvas.drawCircle(Offset(vertices[e[2]].x + center.x, vertices[e[2]].y + center.y), 5.0, x);
        canvas.drawCircle(Offset(vertices[e[3]].x + center.x, vertices[e[3]].y + center.y), 5.0, x);
        canvas.drawLine(
            Offset(vertices[e[0]].x + center.x, vertices[e[0]].y + center.y), Offset(vertices[e[1]].x + center.x, vertices[e[1]].y + center.y), x);
        canvas.drawLine(
            Offset(vertices[e[1]].x + center.x, vertices[e[1]].y + center.y), Offset(vertices[e[2]].x + center.x, vertices[e[2]].y + center.y), x);
        canvas.drawLine(
            Offset(vertices[e[2]].x + center.x, vertices[e[2]].y + center.y), Offset(vertices[e[3]].x + center.x, vertices[e[3]].y + center.y), x);
        canvas.drawLine(
            Offset(vertices[e[3]].x + center.x, vertices[e[3]].y + center.y), Offset(vertices[e[0]].x + center.x, vertices[e[0]].y + center.y), x);
      }
    }
  }

  @override
  bool shouldRepaint(CubePainter old) => old.angleX != angleX || old.angleY != angleY || old._color != _color;
}
