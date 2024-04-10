import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Sample"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                context.push('/modelViewer');
              },
              child: const Text('Model Viewer'),
            ),
            TextButton(
              onPressed: () {
                context.push('/sembast');
              },
              child: const Text('Sembast'),
            ),
            TextButton(
              onPressed: () {
                context.push('/freezed');
              },
              child: const Text('freezed'),
            ),
            TextButton(
              onPressed: () {
                context.push('/anim');
              },
              child: const Text('anim'),
            ),
            TextButton(
              onPressed: () {
                context.push('/inappWebview');
              },
              child: const Text('inAppWebView'),
            ),
            TextButton(
              onPressed: () {
                context.push('/webview');
              },
              child: const Text('WebView'),
            ),
            TextButton(
              onPressed: () {
                context.push('/cuber');
              },
              child: const Text('Cuber'),
            ),
            TextButton(
              onPressed: () {
                context.push('/bunny');
              },
              child: const Text('Bunny'),
            ),
            TextButton(
              onPressed: () {
                context.push('/ruby');
              },
              child: const Text('Ruby'),
            ),
            TextButton(
              onPressed: () {
                context.push('/planet');
              },
              child: const Text('planet'),
            ),
            TextButton(
              onPressed: () {
                context.push('/rubik');
              },
              child: const Text('Rubik'),
            ),
            TextButton(
              onPressed: () {
                context.push('/store_animation');
              },
              child: const Text('Store animation'),
            ),
            TextButton(
              onPressed: () {
                context.push('/obj_3d');
              },
              child: const Text('Obj_3d'),
            ),
            TextButton(
              onPressed: () {
                context.push('/print_cube');
              },
              child: const Text('Print Cube'),
            ),
            TextButton(
              onPressed: () {
                context.push('/animated_toggle');
              },
              child: const Text('Animated toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
