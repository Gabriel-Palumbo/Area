import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/backend/models/brand_service_model.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchListServicesWithActionReaction() async {
  List<Map<String, dynamic>> services = [];
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? baseURL = await secureStorage.read(key: 'baseURL');

  final url = Uri.parse('$baseURL/services/list_service');
  final tokenAuth = await getStoredToken();

  final headers = {
    'Authorization': 'Bearer $tokenAuth',
    'Content-Type': 'application/json',
  };

  final httpService = HttpService();
  try {
    final response = await httpService.client.get(url, headers: headers);
    print("Response: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      services = await convertJsonToServices(data);

      return services;
    } else {
      print('Failed to fetch services: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
  return services;
}

Future<List<Map<String, dynamic>>>
    fetchListServicesWithActionReactionConnected() async {
  List<Map<String, dynamic>> services = [];
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? baseURL = await secureStorage.read(key: 'baseURL');

  final url = Uri.parse('$baseURL/services/list_service_connected');
  final tokenAuth = await getStoredToken();

  final headers = {
    'Authorization': 'Bearer $tokenAuth',
    'Content-Type': 'application/json',
  };

  final httpService = HttpService();

  try {
    final response = await httpService.client.get(url, headers: headers);
    print("Response: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      services = await convertJsonToServicesConnected(data);

      return services;
    } else {
      print('Failed to fetch services: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }

  print("🚙🚙🚙 Services : ${services}");
  return services;
}

///
/// Fetch list of services connected and disconnected without action/reaction
///
Future<List<Map<String, dynamic>>> fetchListServicesConnectionOnly() async {
  List<Map<String, dynamic>> services = [];
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? baseURL = await secureStorage.read(key: 'baseURL');

  final url = Uri.parse('$baseURL/services/list_service_simple');
  final tokenAuth = await getStoredToken();
  final headers = {
    'Authorization': 'Bearer $tokenAuth',
    'Content-Type': 'application/json',
  };

  final httpService = HttpService();

  try {
    final response = await httpService.client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      services = await convertJsonToServicesConnectionOnly(data);
      return services;
    } else {
      print('Failed to fetch services: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
  return services;
}
