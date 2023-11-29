import 'package:flutter/material.dart';

class AnimPage extends StatefulWidget {
  const AnimPage({super.key});

  @override
  State<AnimPage> createState() => _AnimPageState();
}

class _AnimPageState extends State<AnimPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

  bool _hideView = false;

  @override
  void initState() {
    _controller.addStatusListener((status) {

    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Anim')),
      body: Column(
        children: [
          Container(
            height: 80,
            color: Colors.blueGrey,
            alignment: Alignment.center,
            child: Text("header"),
          ),
          Container(
            height: 200,
            color: Colors.lightGreen,
            alignment: Alignment.center,
            child: Text("座位"),
          ),
          Expanded(
            child: Container(
              color: Colors.teal,
              alignment: Alignment.center,
              child: Text("message"),
            ),
          ),
          Container(
            height: 40,
            color: Colors.amberAccent,
            alignment: Alignment.center,
            child: Text("bottom"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.access_alarm),
        onPressed: () {
          setState(() {
            _hideView = !_hideView;
          });
        },
      ),
    );
  }
}
