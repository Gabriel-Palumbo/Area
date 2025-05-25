import 'dart:convert';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StocksApi {
  final String authorizationHeader;

  StocksApi(this.authorizationHeader);

  final httpService = HttpService();

  Future<void> storeStocksInfos(String sender) async {
    final tokenAuth = await getStoredToken();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await httpService.client.post(
        Uri.parse('$baseURL/services/stock/save_token'),
        headers: {
          'Authorization': 'Bearer $tokenAuth',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sender": sender.toLowerCase(),
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print('Failed to store Stocks Infos. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while Stocks Infos: $e');
    }
  }
}
