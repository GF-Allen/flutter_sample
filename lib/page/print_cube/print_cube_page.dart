import 'package:flutter/material.dart';
import 'package:flutter_sample/page/print_cube/print_cube.dart';

class PrintCubePage extends StatefulWidget {
  const PrintCubePage({super.key});

  @override
  State<PrintCubePage> createState() => _PrintCubePageState();
}

class _PrintCubePageState extends State<PrintCubePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('print cube')),
      body: const Cube(),
    );
  }
}
