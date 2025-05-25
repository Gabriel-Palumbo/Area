import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();

  late final IOClient client;

  HttpService._internal() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    client = IOClient(httpClient);
  }

  factory HttpService() {
    return _instance;
  }

  void close() {
    client.close();
  }
}
