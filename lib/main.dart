import 'package:flutter/material.dart';
import 'package:flutter_sample/router/global_router.dart';

import 'page/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: globalRouter,
    );
  }
}
