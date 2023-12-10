import 'dart:ui';

import 'package:three_dart/three3d/three.dart';

/// 每一个方块
class CubeElement {
  final Color color;
  final bool? withLogo;

  Vector3 pos;
  Vector3 normal;

  CubeElement({
    required this.color,
    required this.pos,
    required this.normal,
    this.withLogo,
  });
}

class CubeData {
  /// 阶数
  final int cubeOrder;

  /// 颜色
  final List<Color> colors;

  final double _size = 1;

  final List<CubeElement> _elements = [];

  /// [colors.length = 6 6个面]
  CubeData({this.cubeOrder = 3, required this.colors}) {
    _initElements();
  }

  double get elementSize => _size;

  List<CubeElement> get elements => _elements;

  void _initElements() {
    final border = (cubeOrder * _size) / 2 - 0.5;

    /// 上 下
    for (var x = -border; x <= border; x++) {
      for (var z = -border; z <= border; z++) {
        _elements.add(CubeElement(
          color: colors[0],
          pos: Vector3(x, border + _size * 0.5, z),
          normal: Vector3(0, 1, 0),
        ));

        _elements.add(CubeElement(
          color: colors[1],
          pos: Vector3(x, -border - _size * 0.5, z),
          normal: Vector3(0, -1, 0),
        ));
      }
    }

    /// 左 右
    for (var y = -border; y <= border; y++) {
      for (var z = -border; z <= border; z++) {
        _elements.add(CubeElement(
          color: colors[2],
          pos: Vector3(-border - _size * 0.5, y, z),
          normal: Vector3(-1, 0, 0),
        ));

        _elements.add(CubeElement(
          color: colors[3],
          pos: Vector3(border + _size * 0.5, y, z),
          normal: Vector3(1, 0, 0),
        ));
      }
    }

    /// 前后
    for (var x = -border; x <= border; x++) {
      for (var y = -border; y <= border; y++) {
        _elements.add(CubeElement(
          color: colors[4],
          pos: Vector3(x, y, border + _size * 0.5),
          normal: Vector3(0, 0, 1),
        ));

        _elements.add(CubeElement(
          color: colors[5],
          pos: Vector3(x, y, -border - _size * 0.5),
          normal: Vector3(0, 0, -1),
        ));
      }
    }
  }
}
