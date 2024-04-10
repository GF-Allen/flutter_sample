import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sample/obj/obj_3d_page.dart';
import 'package:flutter_sample/page/buuny_page.dart';
import 'package:flutter_sample/page/cuber_page.dart';
import 'package:flutter_sample/page/freezed_page.dart';
import 'package:flutter_sample/page/model_viewer_page.dart';
import 'package:flutter_sample/page/print_cube/print_cube_page.dart';
import 'package:flutter_sample/page/store_animation/store_page.dart';
import 'package:flutter_sample/page/webview.dart';
import 'package:flutter_sample/rubiks/rubiks_page.dart';
import 'package:go_router/go_router.dart';

import '../page/amin_page.dart';
import '../page/animated_toggle_page.dart';
import '../page/planet_page.dart';
import '../page/ruby_page.dart';
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
    GoRoute(path: "/cuber", builder: (context, state) => const CuberPage()),
    GoRoute(path: "/bunny", builder: (context, state) => const BunnyPage()),
    GoRoute(path: "/ruby", builder: (context, state) => const RubyPage()),
    GoRoute(path: "/planet", builder: (context, state) => const PlanetPage()),
    GoRoute(path: "/Rubik", builder: (context, state) => const RubikPage()),
    GoRoute(path: "/store_animation", builder: (context, state) => const ShoesStorePage()),
    GoRoute(path: "/obj_3d", builder: (context, state) => const Obj3DPage()),
    GoRoute(path: "/print_cube", builder: (context, state) => const PrintCubePage()),
    GoRoute(path: "/animated_toggle", builder: (context, state) => const AnimatedTogglePage()),
  ],
);
