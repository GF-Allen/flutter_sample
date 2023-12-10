import 'package:three_dart/three3d/three.dart';

import 'cube_square.dart';

class RotateDirection {
  /// 屏幕方向向量
  final Vector2 screenDir;

  /// 代表方向的起始square，用于记录旋转的local方向
  final SquareMesh startSquare;

  /// 代表方向的终止square，用于记录旋转的local方向
  final SquareMesh endSquare;

  RotateDirection({
    required this.screenDir,
    required this.startSquare,
    required this.endSquare,
  });
}

class CubeState {
  /// 所有的方块
  final List<SquareMesh> squares;

  /// 是否正处于旋转状态
  bool inRotation = false;

  /// 经旋转的角度（弧度）
  double rotateAnglePI = 0;

  /// 正在旋转的方块
  List<SquareMesh> activeSquares = [];

  /// 控制的方块
  SquareMesh? controlSquare;

  /// 旋转方向
  RotateDirection? rotateDirection;

  /// 旋转轴
  Vector3? rotateAxisLocal;

  CubeState({required this.squares});

  void setRotating({
    required SquareMesh control,
    required List<SquareMesh> actives,
    required RotateDirection direction,
    required Vector3 rotateAxisLocal,
  }) {
    inRotation = true;
    controlSquare = control;
    activeSquares = actives;
    rotateDirection = direction;
    this.rotateAxisLocal = rotateAxisLocal;
  }

  void resetState() {
    inRotation = false;
    activeSquares = [];
    controlSquare = null;
    rotateDirection = null;
    rotateAxisLocal = null;
    rotateAnglePI = 0;
  }

  /// 是否是六面对齐
  bool validateFinish() {
    bool finish = false;
    List<(Vector3, List<SquareMesh>)> sixPlane = [
      (Vector3(0, 1, 0), []),
      (Vector3(0, -1, 0), []),
      (Vector3(-1, 0, 0), []),
      (Vector3(1, 0, 0), []),
      (Vector3(0, 0, 1), []),
      (Vector3(0, 0, -1), []),
    ];

    for (var i = 0; i < squares.length; i++) {
      final plane = sixPlane.firstWhere((item) => squares[i].element.normal.equals(item.$1));
      plane.$2.add(squares[i]);
    }

    for (var i = 0; i < sixPlane.length; i++) {
      var plane = sixPlane[i];
      if (!plane.$2.every((square) => square.element.color == plane.$2[0].element.color)) {
        finish = false;
        break;
      }
    }
    return finish;
  }
}
