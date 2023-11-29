import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerPage extends StatefulWidget {
  const ModelViewerPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ModelViewer();
  }
}

class _ModelViewer extends State<ModelViewerPage> {
  final animList = [
    '_CharacterSucceeds',
    'ClickedOn',
    'Congratulate',
    'Embarrassed',
    'Hide',
    'Pleased',
    'Show',
    'Travel',
    'Writing',
    'Idle',
  ];

  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Flexible(
            child: ModelViewer(
              key: ValueKey(index),
              backgroundColor: Colors.transparent,
              src: 'assets/animation_dog.glb',
              alt: "A 3D model of an astronaut",
              ar: false,
              autoRotate: false,
              cameraControls: false,
              iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
              disableZoom: true,
              autoPlay: true,
              animationName: animList[index],
            ),
          ),
          SizedBox(
            height: 44,
            child: TextButton(
              onPressed: () {
                int i = index + 1;
                if (i >= animList.length) {
                  i = 0;
                }
                setState(() {
                  index = i;
                });
              },
              child: const Text('切换动作'),
            ),
          )
        ],
      ),
    );
  }
}
