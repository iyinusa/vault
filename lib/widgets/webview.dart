import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helper/constant.dart';

class WebViewScreen extends StatefulWidget {
  final String name, url;
  const WebViewScreen({
    Key? key,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late int progress = 0;
  bool isLoaded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 45, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back_outlined),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // progress
            progress < 90
                ? SizedBox(
                    height: screen.height - 150,
                    child: const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  )
                : isLoaded == false
                    ? SizedBox(
                        height: screen.height - 105,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.wifi_off_outlined,
                              size: 120,
                              color: Colors.grey,
                            ),
                            Text(
                              'Please Check Connectivity!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),

            // web view
            Expanded(
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (val) {
                  setState(() {
                    progress = val;
                  });
                },
                onWebResourceError: (error) {
                  setState(() {
                    isLoaded = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
