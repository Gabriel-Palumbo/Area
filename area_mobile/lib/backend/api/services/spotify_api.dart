import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpotifyApi {
  final String authorizationHeader;

  SpotifyApi(this.authorizationHeader);

  final httpService = HttpService();

  // Fonction pour stocker le token GitHub
  Future<void> storeSpotifyInfos(String spotifyID, String secret) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/spotify/store-spotify-token'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "grant_type": 'client_credentials',
          "client_id": spotifyID,
          "client_secret": secret
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to store Spotify Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while storing Spotify Infos: $e');
    }
  }
}
