import 'dart:ui';

import 'package:flutter_sample/rubiks/core/cube_square.dart';
import 'package:three_dart/three3d/three.dart';

import '../utils/utils.dart';
import 'cube_data.dart';
import 'cube_state.dart';

class Cube extends Group {
  late CubeData data;
  late CubeState state;

  Cube({List<Color>? colors, int order = 3}) {
    data = CubeData(
        colors: colors ??
            [
              Color.fromHex(0xfb3636),
              Color.fromHex(0xff9351),
              Color.fromHex(0xfade70),
              Color.fromHex(0x9de16f),
              Color.fromHex(0x51acfa),
              Color.fromHex(0xda6dfa),
            ],
        cubeOrder: order);

    createChildrenByData();

    rotateX(Math.pi * 0.25);
    rotateY(Math.pi * 0.25);

    setFinish(finish);
  }

  List<SquareMesh> squares = [];

  bool get finish => state.validateFinish();

  int get order => data.cubeOrder;

  double get squareSize => data.elementSize;

  void createChildrenByData() {
    removeList(children);
    squares.clear();

    for (var i = 0; i < data.elements.length; i++) {
      var square = createSquare(color: data.elements[i].color, element: data.elements[i]);
      add(square);
      squares.add(square);
    }

    state = CubeState(squares: squares);
  }

  void setFinish(bool finish) {
    /// TODO 更新状态
    print('cube finish: $finish');
  }

  /// 旋转一个面
  void rotateOnePlane({
    required Vector2 mousePrePos,
    required Vector2 mouseCurPos,
    required SquareMesh controlSquare,
    required Camera camera,
    required Size winSize,
  }) {
    if (mouseCurPos.distanceTo(mousePrePos) < 5) {
      return;
    }

    if (!squares.contains(controlSquare)) {
      return;
    }

    final screenDir = mouseCurPos.clone().sub(mousePrePos);
    if (screenDir.x == 0 && screenDir.y == 0) return;

    if (!state.inRotation) {
      final squareScreenPos = _getSquareScreenPos(controlSquare, camera, winSize) as Vector2;

      final squareNormal = controlSquare.element.normal;
      final squarePos = controlSquare.element.pos;

      // 与 controlSquare 在同一面的其他 Square
      final commonDirSquares = squares.where((square) => square.element.normal.equals(squareNormal) && !square.element.pos.equals(squarePos)).toList();

      // square1 和 sqaure2 垂直和竖直方向的同一面的两个 SquareMesh
      SquareMesh? square1;
      SquareMesh? square2;
      for (var i = 0; i < commonDirSquares.length; i++) {
        if (squareNormal.x != 0) {
          if (commonDirSquares[i].element.pos.y == squarePos.y) {
            square1 = commonDirSquares[i];
          }
          if (commonDirSquares[i].element.pos.z == squarePos.z) {
            square2 = commonDirSquares[i];
          }
        } else if (squareNormal.y != 0) {
          if (commonDirSquares[i].element.pos.x == squarePos.x) {
            square1 = commonDirSquares[i];
          }
          if (commonDirSquares[i].element.pos.z == squarePos.z) {
            square2 = commonDirSquares[i];
          }
        } else if (squareNormal.z != 0) {
          if (commonDirSquares[i].element.pos.x == squarePos.x) {
            square1 = commonDirSquares[i];
          }
          if (commonDirSquares[i].element.pos.y == squarePos.y) {
            square2 = commonDirSquares[i];
          }
        }

        if (square1 != null && square2 != null) {
          break;
        }
      }

      if (square1 == null || square2 == null) {
        return;
      }

      final square1ScreenPos = _getSquareScreenPos(square1, camera, winSize) as Vector2;
      final square2ScreenPos = _getSquareScreenPos(square2, camera, winSize) as Vector2;

      // 记录可能旋转的四个方向
      List<RotateDirection> squareDirs = [];

      final squareDir1 = RotateDirection(
        screenDir: Vector2(square1ScreenPos.x - squareScreenPos.x, square1ScreenPos.y - squareScreenPos.y).normalize(),
        startSquare: controlSquare,
        endSquare: square1,
      );

      final squareDir2 =
          RotateDirection(screenDir: Vector2(square2ScreenPos.x - squareScreenPos.x, square2ScreenPos.y - squareScreenPos.y).normalize(), startSquare: controlSquare, endSquare: square2);
      squareDirs.add(squareDir1);

      squareDirs.add(RotateDirection(screenDir: squareDir1.screenDir.clone().negate(), startSquare: square1, endSquare: controlSquare));
      squareDirs.add(squareDir2);
      squareDirs.add(RotateDirection(screenDir: squareDir2.screenDir.clone().negate(), startSquare: square2, endSquare: controlSquare));

      // 根据可能旋转的四个方向向量与鼠标平移方向的夹角确定旋转的方向，夹角最小的方向即为旋转方向
      var minAngle = Math.abs(getAngleBetweenTwoVector2(squareDirs[0].screenDir, screenDir));
      var rotateDir = squareDirs[0]; // 最终确定的旋转方向

      for (var i = 0; i < squareDirs.length; i++) {
        final angle = Math.abs(getAngleBetweenTwoVector2(squareDirs[i].screenDir, screenDir));

        if (minAngle > angle) {
          minAngle = angle;
          rotateDir = squareDirs[i];
        }
      }

      // 旋转轴：用法向量与旋转的方向的叉积计算
      final rotateDirLocal = rotateDir.endSquare.element.pos.clone().sub(rotateDir.startSquare.element.pos).normalize();
      final rotateAxisLocal = squareNormal.clone().cross(rotateDirLocal).normalize(); // 旋转的轴

      // 旋转的方块：由 controlSquare 位置到要旋转的方块的位置的向量，与旋转的轴是垂直的，通过这一特性可以筛选出所有要旋转的方块
      List<SquareMesh> rotateSquares = [];
      final controlTemPos = getTemPos(controlSquare, data.elementSize);

      for (var i = 0; i < squares.length; i++) {
        final squareTemPos = getTemPos(squares[i], data.elementSize);
        final squareVec = controlTemPos.clone().sub(squareTemPos);
        if (squareVec.dot(rotateAxisLocal) == 0) {
          rotateSquares.add(squares[i]);
        }
      }

      state.setRotating(control: controlSquare, actives: rotateSquares, direction: rotateDir, rotateAxisLocal: rotateAxisLocal);
    }

    final rotateSquares = state.activeSquares; // 旋转的方块
    final rotateAxisLocal = state.rotateAxisLocal; // 旋转的轴

    // 旋转的角度：使用 screenDir 在旋转方向上的投影长度，投影长度越长，旋转角度越大
    // 投影长度的正负值影响魔方旋转的角度方向
    // 旋转的角度 = 投影的长度 / 魔方的尺寸 * 90度
    final temAngle = getAngleBetweenTwoVector2(state.rotateDirection!.screenDir, screenDir);
    final screenDirProjectRotateDirLen = Math.cos(temAngle) * screenDir.length();
    final coarseCubeSize = getCoarseCubeSize(camera, winSize);
    final rotateAnglePI = screenDirProjectRotateDirLen / coarseCubeSize * Math.pi * 0.5; // 旋转角度
    final newRotateAnglePI = rotateAnglePI - state.rotateAnglePI;
    state.rotateAnglePI = rotateAnglePI;

    final rotateMat = Matrix4();
    rotateMat.makeRotationAxis(rotateAxisLocal!, newRotateAnglePI);

    for (var i = 0; i < rotateSquares.length; i++) {
      rotateSquares[i].applyMatrix4(rotateMat);
      rotateSquares[i].updateMatrix();
    }
  }

  bool Function(num tick) getAfterRotateAnimation() {
    final needRotateAnglePI = getNeededRotateAngle();
    const rotateSpeed = Math.pi * 0.5 / 500; // 1s 旋转90度

    num? lastTick;
    double rotatedAngle = 0;

    bool rotateTick(num tick) {
      if (lastTick != null) {
        lastTick = tick;
      }
      final time = tick - lastTick!;
      lastTick = tick;
      if (rotatedAngle < Math.abs(needRotateAnglePI)) {
        var curAngle = time * rotateSpeed;
        if (rotatedAngle + curAngle > Math.abs(needRotateAnglePI)) {
          curAngle = Math.abs(needRotateAnglePI) - rotatedAngle;
        }
        rotatedAngle += curAngle;
        curAngle = needRotateAnglePI > 0 ? curAngle : -curAngle;

        final rotateMat = Matrix4();
        rotateMat.makeRotationAxis(state.rotateAxisLocal!, curAngle);
        for (var i = 0; i < state.activeSquares.length; i++) {
          state.activeSquares[i].applyMatrix4(rotateMat);
          state.activeSquares[i].updateMatrix();
        }
        return true;
      } else {
        updateStateAfterRotate();
        return false;
      }
    }

    return rotateTick;
  }

  /// 旋转后更新状态
  void updateStateAfterRotate() {
    // 旋转至正位，有时旋转的不是90度的倍数，需要修正到90度的倍数
    final needRotateAnglePI = getNeededRotateAngle();
    state.rotateAnglePI += needRotateAnglePI;

    // 更新 data：CubeElement 的状态，旋转后法向量、位置等发生了变化
    final angleRelative360PI = state.rotateAnglePI % (Math.pi * 2);
    // const timesOfRight = angleRelative360PI / rightAnglePI; // 旋转的角度相当于几个90度

    if (Math.abs(angleRelative360PI) > 0.1) {
      // 更新位置和法向量
      final rotateMat2 = Matrix4();
      rotateMat2.makeRotationAxis(state.rotateAxisLocal!, angleRelative360PI);

      List<(Vector3, Vector3)> pn = [];

      for (var i = 0; i < state.activeSquares.length; i++) {
        final nor = state.activeSquares[i].element.normal.clone();
        final pos = state.activeSquares[i].element.pos.clone();

        nor.applyMatrix4(rotateMat2); // 旋转后的法向量
        pos.applyMatrix4(rotateMat2); // 旋转后的位置

        // 找到与旋转后对应的方块，更新它的颜色
        for (var j = 0; j < state.activeSquares.length; j++) {
          final nor2 = state.activeSquares[j].element.normal.clone();
          final pos2 = state.activeSquares[j].element.pos.clone();
          if (equalDirection(nor, nor2) && pos.distanceTo(pos2) < 0.1) {
            pn.add((nor2, pos2));
          }
        }
      }

      for (var i = 0; i < state.activeSquares.length; i++) {
        state.activeSquares[i].element.normal = pn[i].$1;
        state.activeSquares[i].element.pos = pn[i].$2;
      }
    }

    state.resetState();
  }

  double getNeededRotateAngle() {
    const rightAnglePI = Math.pi * 0.5;
    final exceedAnglePI = Math.abs(state.rotateAnglePI) % rightAnglePI;
    var needRotateAnglePI = exceedAnglePI > rightAnglePI * 0.5 ? rightAnglePI - exceedAnglePI : -exceedAnglePI;
    needRotateAnglePI = state.rotateAnglePI > 0 ? needRotateAnglePI : -needRotateAnglePI;

    return needRotateAnglePI;
  }

  Vector2? _getSquareScreenPos(SquareMesh square, Camera camera, Size winSize) {
    if (!squares.contains(square)) {
      return null;
    }

    final mat = Matrix4().multiply(square.matrixWorld).multiply(matrix);

    final pos = Vector3().applyMatrix4(mat);
    pos.project(camera);
    return ndcToScreen(pos, winSize);
  }

  num getCoarseCubeSize(Camera camera, Size winSize) {
    final width = order * squareSize;
    final p1 = Vector3(-width / 2, 0, 0);
    final p2 = Vector3(width / 2, 0, 0);
    p1.project(camera);
    p2.project(camera);
    final screenP1 = ndcToScreen(p1, winSize);
    final screenP2 = ndcToScreen(p2, winSize);
    return Math.abs(screenP2.x - screenP1.x);
  }

  Vector3 getTemPos(SquareMesh square, double squareSize) {
    final moveVect = square.element.normal.clone().normalize().multiplyScalar(-0.5 * squareSize);
    final pos = square.element.pos.clone();
    return pos.add(moveVect);
  }
}
