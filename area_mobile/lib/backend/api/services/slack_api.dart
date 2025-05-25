import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SlackApi {
  final String authorizationHeader;

  SlackApi(this.authorizationHeader);

  final httpService = HttpService();

  // Fonction pour stocker le token GitHub
  Future<void> storeSlackInfos(String token, String memberID) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/slack/save-token'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": token,
          "memberId": memberID,
        }),
      );

      if (response.statusCode == 200) {
      } else {
        print('Failed to store Slack Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while Slack Spotify Infos: $e');
    }
  }
}
