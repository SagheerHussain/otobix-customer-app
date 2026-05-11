import 'package:flutter/material.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InsuranceRedirectPage extends StatefulWidget {
  final String url;

  const InsuranceRedirectPage({super.key, required this.url});

  @override
  State<InsuranceRedirectPage> createState() => _InsuranceRedirectPageState();
}

class _InsuranceRedirectPageState extends State<InsuranceRedirectPage> {
  late final WebViewController controller;

  bool isPageLoading = true;
  bool hasError = false;

  static const String _hardcodedErrorMessage =
      'Unable to open the insurance page right now. Please check your internet connection and try again.';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (!mounted) return;
            setState(() {
              isPageLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            if (!mounted) return;
            setState(() {
              isPageLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (!mounted) return;
            setState(() {
              isPageLoading = false;
              hasError = true;
            });
          },
        ),
      );

    _loadPage();
  }

  void _loadPage() {
    final uri = Uri.tryParse(widget.url);

    final isValidUrl =
        uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    if (!isValidUrl) {
      setState(() {
        isPageLoading = false;
        hasError = true;
      });
      return;
    }

    setState(() {
      isPageLoading = true;
      hasError = false;
    });

    controller.loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Insure My Car'),
      body: Stack(
        children: [
          if (!hasError)
            WebViewWidget(controller: controller)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      _hardcodedErrorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          if (isPageLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
        ],
      ),
    );
  }
}
