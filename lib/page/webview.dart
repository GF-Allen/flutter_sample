import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebviewPage extends StatefulWidget {
  const InAppWebviewPage({super.key});

  @override
  State<InAppWebviewPage> createState() => _InAppWebviewPageState();
}

class _InAppWebviewPageState extends State<InAppWebviewPage> {
  final url = 'https://davidwalsh.name/demo/fullscreen.php';

  InAppWebViewController? _controller;

  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null && _isFullScreen) {
          _controller?.evaluateJavascript(source: "document.exitFullscreen()");
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).width,
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: false,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(),
                ios: IOSInAppWebViewOptions(),
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onEnterFullscreen: (controller) {
                _isFullScreen = true;
                debugPrint('-------------------> onEnterFullscreen');
              },
              onExitFullscreen: (controller) {
                _isFullScreen = false;
                debugPrint('-------------------> onExitFullscreen');
              },
              onConsoleMessage: (controller, consoleMessage) {
                if (kDebugMode) {
                  print(consoleMessage);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
