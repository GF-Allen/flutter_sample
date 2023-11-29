import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sample/page/freezed_page.dart';
import 'package:flutter_sample/page/model_viewer_page.dart';
import 'package:flutter_sample/page/webview.dart';
import 'package:go_router/go_router.dart';

import '../page/amin_page.dart';
import '../page/webview_.dart';
import '../page/main_page.dart';
import '../page/sembast_page.dart';

GoRouter globalRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainPage()),
    GoRoute(path: "/modelViewer", builder: (context, state) => const ModelViewerPage()),
    GoRoute(path: "/sembast", builder: (context, state) => const SembastPage()),
    GoRoute(path: "/freezed", builder: (context, state) => const FreezedPage()),
    GoRoute(path: "/anim", builder: (context, state) => const AnimPage()),
    GoRoute(path: "/inappWebview", builder: (context, state) => const InAppWebviewPage()),
    GoRoute(path: "/webview", builder: (context, state) => const WebviewPage()),
  ],
);
