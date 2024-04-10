import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class AnimatedTogglePage extends StatefulWidget {
  const AnimatedTogglePage({super.key});

  @override
  State<AnimatedTogglePage> createState() => _AnimatedTogglePageState();
}

class _AnimatedTogglePageState extends State<AnimatedTogglePage> {
  bool _selected = false;

  final _bgColor = Colors.yellow.withOpacity(0.6);

  final _height = 48.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Toggle')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildToggleWidget(),
            Container(
              width: _height * 2,
              height: _height,
              color: _bgColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggleWidget() {
    return AnimatedToggleSwitch<bool>.dual(
      current: _selected,
      first: false,
      second: true,
      height: _height,
      borderWidth: 0,
      onChanged: (value) {
        setState(() {
          _selected = value;
        });
      },
      styleAnimationType: AnimationType.onHover,
      styleBuilder: (value) => ToggleStyle(
        indicatorColor: Colors.red,
        borderColor: Colors.transparent,
        backgroundColor: value ? _bgColor : Colors.blue,
      ),
    );
  }
}
