import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;

import 'core/cube.dart';
import 'core/cube_control.dart';

class RubiksWidget extends StatefulWidget {
  final double width;
  final double height;
  final int order;
  final List<Color>? cubeColors;
  final Color? backgroundColor;

  const RubiksWidget({
    super.key,
    required this.width,
    required this.height,
    this.order = 3,
    this.cubeColors,
    this.backgroundColor,
  });

  @override
  State<RubiksWidget> createState() => _RubiksWidgetState();
}

class _RubiksWidgetState extends State<RubiksWidget> {
  FlutterGlPlugin? _three3dRender;

  late three.PerspectiveCamera _camera;
  late three.Scene _scene;
  late Cube _cube;
  late three.WebGLRenderer _renderer;
  int? _sourceTexture;

  late three.WebGLRenderTarget _renderTarget;

  late TouchControl _control;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  void _init() async {
    final width = widget.width;
    final height = widget.height;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    _three3dRender = FlutterGlPlugin();

    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": dpr,
    };

    await _three3dRender!.initialize(options: options);

    setState(() {});

    await _three3dRender!.prepareContext();

    _camera = three.PerspectiveCamera(45, 1, 0.1, 100);
    _camera.position.set(0, 0, 15);

    _scene = three.Scene();
    _scene.background = three.Color.fromHex(0x478967);

    _renderer = three.WebGLRenderer({
      "width": width,
      "height": height,
      "gl": _three3dRender!.gl,
      "antialias": true,
      "canvas": _three3dRender!.element,
    });

    _camera.aspect = width / height;
    _camera.updateProjectionMatrix();

    _renderer.setSize(width, height);
    _renderer.setPixelRatio(dpr);

    final pars = three.WebGLRenderTargetOptions({
      "minFilter": three.LinearFilter,
      "magFilter": three.LinearFilter,
      "format": three.RGBAFormat,
      "samples": 4,
    });
    _renderTarget = three.WebGLRenderTarget((width * dpr).toInt(), (height * dpr).toInt(), pars);
    _renderer.setRenderTarget(_renderTarget);

    _sourceTexture = _renderer.getRenderTargetGLTexture(_renderTarget);

    _initCube();
  }

  void _initCube() {
    _cube = Cube(order: widget.order);
    _scene.add(_cube);

    _control = TouchControl(
      cube: _cube,
      renderer: _renderer,
      scene: _scene,
      camera: _camera,
      render: _render,
    );

    _render();

    var coarseSize = _cube.getCoarseCubeSize(_camera, Size(widget.width, widget.height));
    var radio = three.Math.max(2.2 / (widget.width / coarseSize), 2.2 / (widget.height / coarseSize));
    _camera.position.z *= radio;

    _render();
  }

  void _render() {
    _renderer.render(_scene, _camera);
    _three3dRender?.gl.flush();
    _three3dRender?.updateTexture(_sourceTexture);
  }

  @override
  void dispose() {
    _three3dRender?.dispose();
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = (_three3dRender?.isInitialized ?? false)
        ? Texture(textureId: _three3dRender!.textureId!)
        : const Center(
            child: CircularProgressIndicator(),
          );
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) {
          _control.touchStart(d.globalPosition);
          print('touch onPanStart');
        },
        onPanUpdate: (d) {
          _control.touchMove(d.globalPosition);
          print('touch onPanUpdate');
        },
        onPanEnd: (d) {
          var velocity = d.velocity;
          _control.touchEnd();
          print('touch onPanEnd');
        },
        child: child,
      ),
    );
  }
}
