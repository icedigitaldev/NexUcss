import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/logger.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({super.key});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              html { background-color: #000000; }
              body { margin: 0; padding: 0; background-color: #000000; }
              .video-container { position: relative; padding-bottom: 216.48%; height: 0; background-color: #000000; }
              iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: #000000; }
            </style>
          </head>
          <body>
            <div class="video-container">
              <iframe src="https://player.vimeo.com/video/1036962978?badge=0&autopause=0&player_id=0&app_id=58479&autoplay=1&muted=0&background=0"
                frameborder="0"
                allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media"
                allowfullscreen
                title="Tutorial Completo">
              </iframe>
            </div>
            <script src="https://player.vimeo.com/api/player.js"></script>
            <script>
              window.onload = function() {
                var iframe = document.querySelector('iframe');
                var player = new Vimeo.Player(iframe);
                
                player.ready().then(function() {
                  player.setVolume(1);
                  player.setMuted(false);
                });
              }
            </script>
          </body>
        </html>
      ''')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            AppLogger.log('Video cargado correctamente', prefix: 'VIDEO:');
          },
          onWebResourceError: (WebResourceError error) {
            AppLogger.log('Error al cargar el video: ${error.description}', prefix: 'ERROR:');
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}