import 'dart:convert';

import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpService = HttpService();

Future<void> disconnectServices(String serviceName) async {
  try {
    final String? tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    final response = await httpService.client
        .delete(Uri.parse('$baseURL/services/delete_service'),
            headers: {
              'Authorization': 'Bearer $tokenAuth',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'service': serviceName.toLowerCase()}));
    if (response.statusCode == 200) {
      print('Success disconnect service: ${response.statusCode}');
    } else {
      print('Failed to disconnect the service. Status code: ${response.body}');
    }
  } catch (e) {
    print('Failed to execute disconnect service function: $e');
  }
}
