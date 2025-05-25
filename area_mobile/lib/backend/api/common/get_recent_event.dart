import 'dart:convert';

import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/backend/models/brand_service_model.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final httpService = HttpService();

Future<List<Map<String, dynamic>>> getRecentEvent() async {
  try {
    final String? tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');
    List<Map<String, dynamic>> list = [];

    final response = await httpService.client.get(
      Uri.parse('$baseURL/services/recent_event'),
      headers: {
        'Authorization': 'Bearer $tokenAuth',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      list = await convertJsonToRecentEvent(data);

      print("🟢🟢🟢🟢🟢 $list");
      print('Success Get Recent Event: ${response.statusCode}');
      return list;
    } else {
      print('Failed to Get Recent Event. Status code: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Failed to execute Get Recent Event function: $e');
    return [];
  }
}
