import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QuotesApi {
  final String authorizationHeader;

  QuotesApi(this.authorizationHeader);

  final httpService = HttpService();

  // Fonction pour stocker le token GitHub
  Future<void> storeQuotesInfos(
    String serviceSenderName,
  ) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/quotes/save_sender'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sender": serviceSenderName.toLowerCase(),
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to store Quotes Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while Quotes Infos: $e');
    }
  }
}
