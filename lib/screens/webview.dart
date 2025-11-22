import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _webViewController;

  bool _isLoading = true;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageFinished: (String url) {
            Duration delay = const Duration(milliseconds: 200);
            Future.delayed(delay, () {
              setState(() {
                _isLoading = false;
              });
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.padding.top),
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),

            AnimatedOpacity(
              opacity: _isLoading ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                height: 2,
                child: AnimatedFractionallySizedBox(
                  heightFactor: 1,
                  duration: const Duration(milliseconds: 200),
                  widthFactor: _progress / 100.0,
                  child: Container(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
