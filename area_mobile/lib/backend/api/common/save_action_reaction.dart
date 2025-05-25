import 'dart:convert';

import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpService = HttpService();

Future<void> saveActionReaction(
    String serviceName, String action, List<String> reactions) async {
  try {
    final String? tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    final response = await httpService.client.post(
        Uri.parse('$baseURL/services/add_action_reaction'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service': serviceName.toLowerCase(),
          'action': action,
          'reactions': reactions
        }));
    if (response.statusCode == 200) {
      print('Success to save area: ${response.statusCode}');
    } else {
      print('Failed to to save area. Status code: ${response.body}');
    }
  } catch (e) {
    print('Failed to execute save area: $e');
  }
}
