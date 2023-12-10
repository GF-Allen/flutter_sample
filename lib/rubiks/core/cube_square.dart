import 'package:flutter_sample/rubiks/core/cube_data.dart';
import 'package:three_dart/three3d/three.dart';

/// 方块
class SquareMesh extends Object3D {
  final CubeElement element;

  SquareMesh({required this.element});
}

/// 创建一个方块
SquareMesh createSquare({
  required Color color,
  required CubeElement element,
}) {
  int x = 0, y = 0;

  final squareShape = Shape(null);

  squareShape.moveTo(x - 0.4, y + 0.5);
  squareShape.lineTo(x + 0.4, y + 0.5);
  squareShape.bezierCurveTo(x + 0.5, y + 0.5, x + 0.5, y + 0.5, x + 0.5, y + 0.4);

  // right
  squareShape.lineTo(x + 0.5, y - 0.4);
  squareShape.bezierCurveTo(x + 0.5, y - 0.5, x + 0.5, y - 0.5, x + 0.4, y - 0.5);

  // bottom
  squareShape.lineTo(x - 0.4, y - 0.5);
  squareShape.bezierCurveTo(x - 0.5, y - 0.5, x - 0.5, y - 0.5, x - 0.5, y - 0.4);

  // left
  squareShape.lineTo(x - 0.5, y + 0.4);
  squareShape.bezierCurveTo(x - 0.5, y + 0.5, x - 0.5, y + 0.5, x - 0.4, y + 0.5);

  final geometry = ShapeGeometry(squareShape);
  final material = MeshBasicMaterial({'color': color});
  final mesh = Mesh(geometry, material);
  mesh.scale = Vector3(0.9, 0.9, 0.9);

  final square = SquareMesh(element: element);
  square.add(mesh);

  final mat2 = MeshBasicMaterial({
    'color': Color(0.0, 0.0, 0.0),
    'side': DoubleSide,
  });

  final plane = Mesh(geometry, mat2);
  plane.position.set(0, 0, -0.01);
  square.add(plane);

  final posX = element.pos.x;
  final posY = element.pos.y;
  final posZ = element.pos.z;
  square.position.set(posX, posY, posZ);

  if (element.withLogo == true) {
    /// TODO textureLoader
  }

  square.lookAt(element.pos.clone().add(element.normal));
  return square;
}
