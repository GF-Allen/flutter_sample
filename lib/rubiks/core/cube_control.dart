import 'dart:ui';

import 'package:flutter_sample/rubiks/core/cube.dart';
import 'package:three_dart/three_dart.dart';

import '../utils/utils.dart';
import 'cube_square.dart';

/// 控制器
abstract class CubeControl {
  final Cube cube;
  final WebGLRenderer renderer;
  final Scene scene;
  final PerspectiveCamera camera;

  final VoidCallback render;

  SquareMesh? _square;
  bool start = false;
  bool lastOperateUnfinish = false;
  Vector2 startPos = Vector2();

  Raycaster raycaster = Raycaster();

  CubeControl({
    required this.cube,
    required this.render,
    required this.renderer,
    required this.scene,
    required this.camera,
  });

  IntersectSquareWrap? getIntersects(double offsetX, double offsetY) {
    final x = (offsetX / renderer.width) * 2 - 1;
    final y = -(offsetY / renderer.height) * 2 + 1;

    raycaster.setFromCamera(Vector2(x, y), camera);

    List<IntersectSquareWrap> intersectSquares = [];
    for (var i = 0; i < cube.squares.length; i++) {
      /// intersectObjects recursive ???
      var intersects = raycaster.intersectObjects([cube.squares[i]], true);
      if (intersects.isNotEmpty) {
        intersectSquares.add(IntersectSquareWrap(intersects[0].distance, cube.squares[i]));
      }
    }

    intersectSquares.sort((item1, item2) => (item1.distance - item2.distance).toInt());

    if (intersectSquares.isNotEmpty) {
      return intersectSquares[0];
    }
    return null;
  }

  void operateStart(double offsetX, double offsetY) {
    if (start) {
      return;
    }
    start = true;
    startPos = Vector2();
    final intersect = getIntersects(offsetX, offsetY);

    _square = null;
    if (intersect != null) {
      _square = intersect.square;
      startPos = Vector2(offsetX, offsetY);
    }
  }

  void operateDrag(double offsetX, double offsetY, double movementX, double movementY) {
    if (start && lastOperateUnfinish == false) {
      if (_square != null) {
        final curMousePos = Vector2(offsetX, offsetY);
        cube.rotateOnePlane(mousePrePos: startPos, mouseCurPos: curMousePos, controlSquare: _square!, camera: camera, winSize: Size(renderer.width, renderer.height));
      } else {
        final dx = movementX;
        final dy = -movementY;

        final movementLen = Math.sqrt(dx * dx + dy * dy);
        final cubeSize = cube.getCoarseCubeSize(camera, Size(renderer.width, renderer.height));

        final rotateAngle = Math.pi * movementLen / cubeSize;

        final moveVect = Vector2(dx, dy);
        final rotateDir = moveVect.rotateAround(Vector2(0, 0), Math.pi * 0.5);

        rotateAroundWorldAxis(cube, Vector3(rotateDir.x, rotateDir.y, 0), rotateAngle);
      }
      _render();
    }
  }

  void operateEnd() {
    if (lastOperateUnfinish == false) {
      if (_square != null) {
        final rotateAnimation = cube.getAfterRotateAnimation();
        lastOperateUnfinish = true;
        void animation(num time) {
          final next = rotateAnimation(time);
          _render();
          if (next) {
            requestAnimationFrame(animation);
          } else {
            cube.setFinish(cube.finish);
            lastOperateUnfinish = false;
          }
        }

        requestAnimationFrame(animation);
      }
      start = false;
      _square = null;
    }
  }

  void _render() {
    render.call();
  }

  int _time = 0;

  void requestAnimationFrame(Function(num time) animation) {
    animation(++_time);
  }

  dispose();
}

class TouchControl extends CubeControl {
  Offset? _lastPos;

  TouchControl({
    required super.cube,
    required super.renderer,
    required super.scene,
    required super.camera,
    required super.render,
  });

  void touchStart(Offset pos) {
    _lastPos = pos;
    operateStart(pos.dx, pos.dy);
  }

  void touchMove(Offset pos) {
    operateDrag(pos.dx, pos.dy, pos.dx - _lastPos!.dx, pos.dy - _lastPos!.dy);
    _lastPos = pos;
  }

  void touchEnd() {
    _lastPos = null;
    operateEnd();
  }

  @override
  dispose() {}
}

class IntersectSquareWrap {
  final num distance;
  final SquareMesh square;

  IntersectSquareWrap(this.distance, this.square);
}
