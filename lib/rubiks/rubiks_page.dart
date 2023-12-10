import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:flutter_gl/flutter_gl.dart';

import 'rubiks_widget.dart';

class RubikPage extends StatefulWidget {
  const RubikPage({super.key});

  @override
  State<RubikPage> createState() => _RubikPageState();
}

class _RubikPageState extends State<RubikPage> {
  // late final _three3dRender = FlutterGlPlugin();
  //
  // late final _camera = three.PerspectiveCamera(45, 1, 0.1, 100);
  //
  // late final _scene = three.Scene();


  late FlutterGlPlugin _three3dRender;
  three.WebGLRenderer? _renderer;

  int? fboId;
  late double width;
  late double height;

  Size? screenSize;

  late three.Scene scene;
  late three.Camera camera;
  late three.Mesh mesh;

  late three.Camera cameraPerspective;
  late three.Camera cameraOrtho;

  late three.Group cameraRig;

  late three.Camera activeCamera;
  late three.CameraHelper activeHelper;

  late three.CameraHelper cameraOrthoHelper;
  late three.CameraHelper cameraPerspectiveHelper;

  int frustumSize = 600;

  double dpr = 1.0;

  num aspect = 1.0;

  var amount = 4;

  bool verbose = true;
  bool disposed = false;

  late three.WebGLRenderTarget renderTarget;

  dynamic sourceTexture;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initSize(context);
    });
  }

  Future<void> initPlatformState() async {
    width = screenSize!.width;
    height = screenSize!.height;

    _three3dRender = FlutterGlPlugin();

    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": dpr
    };

    await _three3dRender.initialize(options: options);

    setState(() {});

    // Wait for web
    Future.delayed(const Duration(milliseconds: 100), () async {
      await _three3dRender.prepareContext();

      initScene();
    });
  }

  initSize(BuildContext context) {
    if (screenSize != null) {
      return;
    }

    final mqd = MediaQuery.of(context);

    screenSize = mqd.size;
    dpr = mqd.devicePixelRatio;

    initPlatformState();
  }

  initScene() {
    initRenderer();
    initPage();
  }

  render() {
    int t = DateTime.now().millisecondsSinceEpoch;

    final gl = _three3dRender.gl;

    var r = DateTime.now().millisecondsSinceEpoch * 0.0005;

    mesh.position.x = 700 * three.Math.cos(r);
    mesh.position.z = 700 * three.Math.sin(r);
    mesh.position.y = 700 * three.Math.sin(r);

    mesh.children[0].position.x = 70 * three.Math.cos(2 * r);
    mesh.children[0].position.z = 70 * three.Math.sin(r);

    if (activeCamera == cameraPerspective) {
      cameraPerspective.fov = 35 + 30 * three.Math.sin(0.5 * r);
      cameraPerspective.far = mesh.position.length();
      cameraPerspective.updateProjectionMatrix();

      cameraPerspectiveHelper.update();
      cameraPerspectiveHelper.visible = true;

      cameraOrthoHelper.visible = false;
    } else {
      cameraOrtho.far = mesh.position.length();
      cameraOrtho.updateProjectionMatrix();

      cameraOrthoHelper.update();
      cameraOrthoHelper.visible = true;

      cameraPerspectiveHelper.visible = false;
    }

    cameraRig.lookAt(mesh.position);

    _renderer!.clear();

    activeHelper.visible = false;

    _renderer!.setViewport(0, 0, width / 2, height);
    _renderer!.render(scene, activeCamera);

    activeHelper.visible = true;

    _renderer!.setViewport(width / 2, 0, width / 2, height);
    _renderer!.render(scene, camera);

    int t1 = DateTime.now().millisecondsSinceEpoch;

    if (verbose) {
      print("render cost: ${t1 - t} ");
      print(_renderer!.info.memory);
      print(_renderer!.info.render);
    }

    // 重要 更新纹理之前一定要调用 确保gl程序执行完毕
    gl.flush();

    // var pixels = _gl.readCurrentPixels(0, 0, 10, 10);
    // print(" --------------pixels............. ");
    // print(pixels);

    if (verbose) print(" render: sourceTexture: $sourceTexture ");

    _three3dRender.updateTexture(sourceTexture);
  }

  initRenderer() {
    Map<String, dynamic> options = {
      "width": width,
      "height": height,
      "gl": _three3dRender.gl,
      "antialias": true,
      "canvas": _three3dRender.element
    };
    _renderer = three.WebGLRenderer(options);
    _renderer!.setPixelRatio(dpr);
    _renderer!.setSize(width, height, false);
    _renderer!.shadowMap.enabled = false;
    _renderer!.autoClear = false;

    var pars = three.WebGLRenderTargetOptions(
        {"minFilter": three.LinearFilter, "magFilter": three.LinearFilter, "format": three.RGBAFormat, "samples": 4});
    renderTarget = three.WebGLRenderTarget((width * dpr).toInt(), (height * dpr).toInt(), pars);
    _renderer!.setRenderTarget(renderTarget);

    sourceTexture = _renderer!.getRenderTargetGLTexture(renderTarget);
  }


  initPage() {
    aspect = width / height;

    scene = three.Scene();

    //

    camera = three.PerspectiveCamera(50, 0.5 * aspect, 1, 10000);
    camera.position.z = 2500;

    cameraPerspective = three.PerspectiveCamera(50, 0.5 * aspect, 150, 1000);

    cameraPerspectiveHelper = three.CameraHelper(cameraPerspective);
    scene.add(cameraPerspectiveHelper);

    //
    cameraOrtho = three.OrthographicCamera(
        0.5 * frustumSize * aspect / -2, 0.5 * frustumSize * aspect / 2, frustumSize / 2, frustumSize / -2, 150, 1000);

    cameraOrthoHelper = three.CameraHelper(cameraOrtho);
    scene.add(cameraOrthoHelper);

    //

    activeCamera = cameraPerspective;
    activeHelper = cameraPerspectiveHelper;

    // counteract different front orientation of cameras vs rig

    cameraOrtho.rotation.y = three.Math.pi;
    cameraPerspective.rotation.y = three.Math.pi;

    cameraRig = three.Group();

    cameraRig.add(cameraPerspective);
    cameraRig.add(cameraOrtho);

    scene.add(cameraRig);

    //

    mesh =
        three.Mesh(three.SphereGeometry(100, 16, 8), three.MeshBasicMaterial({"color": 0xffffff, "wireframe": true}));
    scene.add(mesh);

    var mesh2 =
    three.Mesh(three.SphereGeometry(50, 16, 8), three.MeshBasicMaterial({"color": 0x00ff00, "wireframe": true}));
    mesh2.position.y = 150;
    mesh.add(mesh2);

    var mesh3 =
    three.Mesh(three.SphereGeometry(5, 16, 8), three.MeshBasicMaterial({"color": 0x0000ff, "wireframe": true}));
    mesh3.position.z = 150;
    cameraRig.add(mesh3);

    //

    var geometry = three.BufferGeometry();
    List<double> vertices = [];

    for (var i = 0; i < 10000; i++) {
      vertices.add(three.MathUtils.randFloatSpread(2000)); // x
      vertices.add(three.MathUtils.randFloatSpread(2000)); // y
      vertices.add(three.MathUtils.randFloatSpread(2000)); // z

    }

    geometry.setAttribute('position', three.Float32BufferAttribute(Float32Array.fromList(vertices), 3));

    var particles = three.Points(geometry, three.PointsMaterial({"color": 0x888888, "size": 1}));
    scene.add(particles);

    animate();
  }

  animate() {
    if (!mounted || disposed) {
      return;
    }

    render();

    Future.delayed(const Duration(milliseconds: 40), () {
      animate();
    });
  }

  @override
  void dispose() {
    print(" dispose ............. ");

    disposed = true;
    _three3dRender.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rubik')),
      body: RubiksWidget(width: 400, height: 400),
    );
  }
}
