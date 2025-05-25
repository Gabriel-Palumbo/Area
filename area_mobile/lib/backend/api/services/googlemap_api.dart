import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleMapApi {
  final String authorizationHeader;

  GoogleMapApi(this.authorizationHeader);

  final httpService = HttpService();

  // Fonction pour stocker le token GitHub
  Future<void> storeGoogleMapInfos(
      String sender, String origin, String destination, String apikey) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/maps/save_sender'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sender": sender.toLowerCase(),
          "origin": origin,
          "destination": destination,
          "apikey": apikey
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to store CoinCap Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while CoinCap Infos: $e');
    }
  }
}
