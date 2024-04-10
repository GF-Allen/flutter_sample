import 'package:flutter/material.dart';

import 'obj_3d.dart';

class Obj3DPage extends StatefulWidget {
  const Obj3DPage({super.key});

  @override
  State<Obj3DPage> createState() => _Obj3DPageState();
}

class _Obj3DPageState extends State<Obj3DPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter 3D"),
      ),
      body: Center(
        child: Object3D(
          size: const Size(400.0, 400.0),
          path: "assets/obj/file.obj",
          asset: true,
        ),
      ),
    );
  }
}
