import 'package:area_mobile/app/pages/home_widget/home_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final secureStorage = FlutterSecureStorage();

Future<void> loginWithGoogle(BuildContext context) async {
  final String clientId =
      '787330002478-lvn04crnloah007solc8t2blfkjug74p.apps.googleusercontent.com';
  final String redirectUri = 'https://localhost:8080';
  final String url =
      'https://accounts.google.com/o/oauth2/v2/auth?response_type=token&client_id=$clientId&redirect_uri=$redirectUri&scope=email%20profile';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          GoogleOAuthInAppWebView(initialUrl: url, redirectUri: redirectUri),
    ),
  );
}

class GoogleOAuthInAppWebView extends StatefulWidget {
  final String initialUrl;
  final String redirectUri;

  GoogleOAuthInAppWebView(
      {required this.initialUrl, required this.redirectUri});

  @override
  _GoogleOAuthInAppWebViewState createState() =>
      _GoogleOAuthInAppWebViewState();
}

class _GoogleOAuthInAppWebViewState extends State<GoogleOAuthInAppWebView> {
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign In')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController webViewController) {
          _controller = webViewController;
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          if (url != null && url.toString().startsWith(widget.redirectUri)) {
            final token = Uri.parse(url.toString())
                .fragment
                .split('&')
                .firstWhere((element) => element.startsWith('access_token'))
                .split('=')[1];

            // Store the token securely
            await secureStorage.write(key: 'google_auth_token', value: token);

            // Show a success dialog
            _showSuccessDialog(context);
          }
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Successful'),
          content:
              Text('You are successfully signed in to your Google account.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Close the InAppWebView

                // Redirect to the home page or any other page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageWidget()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
