import 'package:area_mobile/app/pages/sign_widget/github_sign.dart';
import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/io_client.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_appauth/flutter_appauth.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final String clientId = 'Ov23liNSi0VOzvm4Gfh8';
  final String redirectUrl = 'com.votreapp://callback';
  final String authorizationEndpoint =
      'https://github.com/login/oauth/authorize';
  final String tokenEndpoint = 'https://github.com/login/oauth/access_token';
  final List<String> scopes = ['read:user', 'user:email'];
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  SignupPage({super.key});

  AreaTheme areaTheme = AreaTheme();

  bool passwordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  // final GithubAuthService githubAuthService = GithubAuthService();

  Future<void> register(BuildContext context) async {
    final String name = nameController.text;
    final String lastname = lastnameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final httpService = HttpService();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await changeBaseURL(null);
    String? baseURL = await secureStorage.read(key: 'baseURL');
    final url = Uri.parse('$baseURL/register');

    try {
      final response = await httpService.client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'firstNameReq': name ?? "Captain",
            'lastNameReq': lastname ?? "Code"
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await secureStorage.write(key: 'auth_token', value: token);
        print("================> ${data}");
        String? tokenFromSecureStorage =
            await secureStorage.read(key: 'auth_token');
        navigationManager(context, "/home", RouterTypes.go);
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['message']}')),
        );
      }
    } catch (error) {
      print('Erreur de connexion: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $error')),
      );
    }
  }

  Future<void> authenticate() async {
    try {
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
          ),
          scopes: scopes,
        ),
      );

      if (result != null) {
        String? accessToken = result.accessToken;
        fetchGitHubProfile(accessToken!);
      }
    } catch (e) {
      print('Erreur d\'authentification: $e');
    }
  }

  Future<void> fetchGitHubProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'token $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> profile = json.decode(response.body);
    } else {
      print('Erreur lors de la récupération du profil: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'S’inscrire',
          style: areaTheme.textWhite_20,
        ),
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
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Inscrivez-vous',
                    style: areaTheme.textTitleWhiteBold,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Prénom',
                            labelStyle: areaTheme.textBoldWhite_18,
                            filled: true,
                            fillColor: areaTheme.subSubGrey,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: TextField(
                          controller: lastnameController,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            labelStyle: areaTheme.textBoldWhite_18,
                            filled: true,
                            fillColor: areaTheme.subSubGrey,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: areaTheme.textBoldWhite_18,
                      filled: true,
                      fillColor: areaTheme.subSubGrey,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Créer votre compte',
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
                      // Action pour s'inscrire avec Google
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 30, 30),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 49, 49, 49)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google-logo.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        Text('S’inscrire avec Google',
                            style: areaTheme.textWhite_16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await authenticate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 30, 30),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 49, 49, 49)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/github.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        Text('S’inscrire avec GitHub',
                            style: areaTheme.textWhite_16),
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
