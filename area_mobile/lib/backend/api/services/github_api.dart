import 'dart:convert';
import 'package:area_mobile/backend/global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GithubApi {
  final String authorizationHeader;

  GithubApi(this.authorizationHeader);

  // Fonction pour stocker le token GitHub
  Future<void> storeGithubToken(
      String githubToken, Function onSuccess, Function onError) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await http.post(
        Uri.parse('$baseURL/services/github/store-token'),
        headers: {
          'Authorization': authorizationHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'githubToken': githubToken,
        }),
      );
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError(
            'Failed to store GitHub token. Status code: ${response.statusCode}');
      }
    } catch (e) {
      onError('Error occurred while storing GitHub token: $e');
    }
  }

  // Fonction pour récupérer les dépôts GitHub
  Future<void> getGithubRepos(
      Function(List<String>) onSuccess, Function onError) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await http.get(
        Uri.parse('$baseURL/services/github/repos'),
        headers: {
          'Authorization': authorizationHeader,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> repos = List<String>.from(data['repositories']);
        onSuccess(repos);
      } else {
        onError(
            'Failed to get GitHub repositories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      onError('Error occurred while fetching GitHub repositories: $e');
    }
  }

  // Fonction pour créer un webhook GitHub
  Future<void> createWebhook(
      String repoFullName, Function onSuccess, Function onError) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? baseURL = await secureStorage.read(key: 'baseURL');

    try {
      final response = await http.post(
        Uri.parse('$baseURL/services/github/create-webhook'),
        headers: {
          'Authorization': authorizationHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'repoFullName': repoFullName,
        }),
      );
      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError(
            'Failed to create webhook. Status code: ${response.statusCode}');
      }
    } catch (e) {
      onError('Error occurred while creating webhook: $e');
    }
  }
}
