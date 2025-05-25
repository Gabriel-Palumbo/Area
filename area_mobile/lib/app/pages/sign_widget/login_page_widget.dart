import 'dart:io';

import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../backend/google_auth.dart';
import 'package:http/io_client.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  AreaTheme areaTheme = AreaTheme();

  Future<void> login(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;
    final httpService = HttpService();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await changeBaseURL(null);
    String? baseURL = await secureStorage.read(key: 'baseURL');
    final url = Uri.parse('$baseURL/login');

    try {
      final response = await httpService.client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await secureStorage.write(key: 'auth_token', value: token);

        String? tokenFromSecureStorage =
            await secureStorage.read(key: 'auth_token');
        navigationManager(context, "/home", RouterTypes.go);
      } else {
        final data = jsonDecode(response.body);
        print('Erreur: ${data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${data['message']}')),
        );
      }
    } catch (error) {
      print('❌ Erreur de connexion: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil', style: areaTheme.textWhite_20),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: areaTheme.blackGrey,
              borderRadius:
                  BorderRadius.circular(20.0), // Rayon des coins arrondis
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Connectez-vous',
                    style: areaTheme.textTitleWhiteBold,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: areaTheme.textBoldWhite_18,
                      filled: true,
                      fillColor: areaTheme.subSubGrey,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: areaTheme.textBoldWhite_18,
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: areaTheme.textBoldWhite_18,
                      filled: true,
                      fillColor: areaTheme.subSubGrey,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Action pour mot de passe oublié
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Se connecter',
                      style: areaTheme.textBoldWhite_18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          height: 1,
                          color: const Color.fromARGB(255, 49, 49, 49),
                        ),
                      ),
                      const Text(
                        'Ou',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0),
                          height: 1,
                          color: const Color.fromARGB(255, 49, 49, 49),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      loginWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 31, 30, 30), // Même couleur que le formulaire
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Coins moins arrondis
                        side: const BorderSide(
                          color: Color.fromARGB(255, 49, 49, 49),
                        ), // Bordure blanche
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google-logo.png', // Remplacez par le chemin de votre image
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Se connecter avec Google',
                          style: areaTheme.textWhite_16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Action pour se connecter avec GitHub
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 31, 30, 30), // Même couleur que le formulaire
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Coins moins arrondis
                        side: const BorderSide(
                            color: Color.fromARGB(
                                255, 49, 49, 49)), // Bordure blanche
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/github.png', // Remplacez par le chemin de votre image
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Se connecter avec GitHub',
                          style: areaTheme.textWhite_16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
