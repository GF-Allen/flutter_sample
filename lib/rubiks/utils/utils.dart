import 'dart:ui';

import 'package:three_dart/three_dart.dart';

void rotateAroundWorldAxis(Object3D object, Vector3 axis, double radians) {
  final mat = Matrix4();
  mat.makeRotationAxis(axis.normalize(), radians);
  mat.multiply(object.matrix);
  object.matrix = mat;
  object.rotation.setFromRotationMatrix(object.matrix);
}

Vector2 ndcToScreen(Vector3 ndc, Size screen) {
  final halfW = screen.width * 0.5;
  final halfH = screen.height * 0.5;

  final x = (ndc.x * halfW) + halfW;
  final y = halfH - (ndc.y * halfH);

  return Vector2(x, y);
}

double getAngleBetweenTwoVector2(Vector2 vec1, Vector2 vec2) {
  final dotValue = vec1.clone().dot(vec2);
  final angle = Math.acos(dotValue / (vec1.length() * vec2.length()));
  return angle;
}

bool equalDirection(Vector3 vec1, Vector3 vec2, {double precision = 0.1}) {
  final angle = vec1.angleTo(vec2);
  return Math.abs(angle) < precision;
}
