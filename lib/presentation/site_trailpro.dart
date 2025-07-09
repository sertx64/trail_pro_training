import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:trailpro_planning/presentation/theme/app_colors.dart';

class SiteTrailpro extends StatefulWidget {
  const SiteTrailpro({super.key});

  @override
  State<SiteTrailpro> createState() => _SiteTrailproState();
}

class _SiteTrailproState extends State<SiteTrailpro> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language),
            SizedBox(width: 8),
            Text('TrailPro.ru'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Прогресс-бар загрузки
              if (_isLoading && _progress < 1.0)
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              
              // WebView
              Expanded(
                child: _hasError
                    ? _buildErrorWidget()
                    : InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri('https://trailpro.ru'),
                        ),
                        onWebViewCreated: (controller) {
                          _webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                        },
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            _progress = progress / 100.0;
                          });
                        },
                        onLoadStop: (controller, url) {
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        onReceivedError: (controller, request, error) {
                          setState(() {
                            _isLoading = false;
                            _hasError = true;
                          });
                        },
                        initialSettings: InAppWebViewSettings(
                          useShouldOverrideUrlLoading: true,
                          mediaPlaybackRequiresUserGesture: false,
                          allowsInlineMediaPlayback: true,
                          javaScriptEnabled: true,
                          supportZoom: true,
                          builtInZoomControls: false,
                          displayZoomControls: false,
                        ),
                      ),
              ),
            ],
          ),
          
          // Индикатор загрузки
          if (_isLoading && _progress == 0.0)
            Container(
              color: Theme.of(context).colorScheme.background,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Ошибка загрузки',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Не удалось загрузить сайт TrailPro.ru',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Проверьте подключение к интернету и попробуйте снова',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _isLoading = true;
                    });
                    _webViewController.reload();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Повторить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
