import 'dart:math';

class Vertex {
  Vertex(this.x, this.y, this.z);

  double x;
  double y;
  double z;

  double deg2rad(double angle) => (angle * (pi / 180));

  @override
  String toString() {
    return "$x $y $z";
  }

  Vertex rotateY(double angle) {
    final double _x = (x * cos(deg2rad(angle))) - (z * sin(deg2rad(angle)));
    final double _z = (x * sin(deg2rad(angle))) + (z * cos(deg2rad(angle)));
    return Vertex(_x, y, _z);
  }

  Vertex rotateX(double angle) {
    final double _y = (y * cos(deg2rad(angle))) - (z * sin(deg2rad(angle)));
    final double _z = (y * sin(deg2rad(angle))) + (z * cos(deg2rad(angle)));
    return Vertex(x, _y, _z);
  }

  Vertex rotateZ(double angle) {
    final double _x = (x * cos(deg2rad(angle))) - (y * sin(deg2rad(angle)));
    final double _y = (x * sin(deg2rad(angle))) + (y * cos(deg2rad(angle)));
    return Vertex(_x, _y, z);
  }

  Vertex convert2D(double fov, double distance) {
    final double f = fov / (z + distance);
    x = x * f;
    y = y * f;
    return Vertex(x, y, z);
  }
}
