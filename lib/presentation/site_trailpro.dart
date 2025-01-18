import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SiteTrailpro extends StatefulWidget {
  const SiteTrailpro({super.key});

  @override
  State<SiteTrailpro> createState() => _SiteTrailproState();
}

class _SiteTrailproState extends State<SiteTrailpro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('TrailPro.ru'),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri('https://trailpro.ru')),
      ),
    );
  }
}
