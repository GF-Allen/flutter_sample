import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final url = 'https://davidwalsh.name/demo/fullscreen.php';

  WebViewController? _controller;

  bool _isFullScreen = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _controller = WebViewController()
      ..setOnConsoleMessage((message) {
        debugPrint('ConsoleMessage ${message.message}');
      })
      ..setBackgroundColor(Colors.transparent)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
    ;
    _controller!.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var result = await _controller?.canGoBack();
        if (result == true) {
          _controller?.goBack();
          return false;
        }
        // if (_controller != null && _isFullScreen) {
        //   _controller?.runJavaScript("document.exitFullscreen()");
        //   return false;
        // }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).width,
            child: WebViewWidget(
              controller: _controller!,
            ),
          ),
        ),
      ),
    );
  }
}
