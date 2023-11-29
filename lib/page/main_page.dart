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
          ],
        ),
      ),
    );
  }
}
