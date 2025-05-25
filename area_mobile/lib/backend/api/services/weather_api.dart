import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WeatherApi {
  final String authorizationHeader;

  WeatherApi(this.authorizationHeader);

  final httpService = HttpService();

  // Fonction pour stocker le token GitHub
  Future<void> storeWeatherInfos(
    String city,
    String serviceSenderName,
  ) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');
    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/weather/save_ville_token'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "ville": city.toLowerCase(),
          "sender": serviceSenderName.toLowerCase(),
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to store Weather Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while Weather Infos: $e');
    }
  }
}
