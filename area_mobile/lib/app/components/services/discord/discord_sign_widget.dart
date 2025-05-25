import 'dart:convert';

import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/common/disconnect_service.dart';
import 'package:area_mobile/backend/api/services/discord_api.dart';
import 'package:area_mobile/backend/api/services/github_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class DiscordSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const DiscordSignUpWidget({
    super.key,
    required this.serviceName,
    required this.serviceData,
  });

  @override
  State<StatefulWidget> createState() => DiscordSignUpWidgetState();
}

class DiscordSignUpWidgetState extends State<DiscordSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  final TextEditingController discordIDController = TextEditingController();
  final TextEditingController discordURLController = TextEditingController();
  final TextEditingController channelIDController = TextEditingController();

  final PageController _pageController = PageController();
  bool isLoading = false;
  String selectedRepo = '';
  List<String> repositories = [];
  String _url =
      "https://discord.com/oauth2/authorize?client_id=1290751460153364490";

  late DiscordApi discordApi;

  DiscordApi setDiscordApi() {
    final tokenAuth = getStoredToken();
    return DiscordApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    discordApi = setDiscordApi();
    discordURLController.text = _url;
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      discordIDController.text = data.text!;
    }
  }

  void goNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 2,
      decoration: BoxDecoration(color: areaTheme.backgroundPage),
      child: Builder(
        builder: (context) {
          if (widget.serviceData['is_connected'] == false) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        0,
                        20,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Suivez les étapes pour vous connecter à Discord afin d’être informé des événements dans votre serveur.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ), // Durée de l'animation
                                  curve: Curves.easeInOut, // Courbe d'animation
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.bleu,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Commencer',
                                style: areaTheme.textBoldWhite_18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: areaTheme.subSubGrey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text("Étape 1", style: areaTheme.textGrey_16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 380,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/Screencastfrom2024-11-0304-36-39-ezgif.com-video-to-gif-converter.gif?alt=media&token=0628b4e6-303e-4cb5-8b3b-ed67e7a65f4f",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Dans l'application Discord web, clique sur les Paramètres utilisateur en bas à gauche (l'icône en forme de roue dentée).",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 380,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/Screencastfrom2024-11-0304-39-40-ezgif.com-video-to-gif-converter.gif?alt=media&token=399b6d65-c2f3-49a5-bee5-f76de3b4056f",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Dans le menu, va dans Paramètres avancés.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 380,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/Screencastfrom2024-11-0304-40-48-ezgif.com-video-to-gif-converter.gif?alt=media&token=5bf76c5d-f6db-44a8-b286-27402f04c1a3",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Active le Mode développeur. Cela te permettra de copier les IDs dans Discord.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ), // Durée de l'animation
                                  curve: Curves.easeInOut, // Courbe d'animation
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.bleu,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "C'est fait!",
                                style: areaTheme.textBoldWhite_18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: areaTheme.subSubGrey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text("Étape 2", style: areaTheme.textGrey_16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Copiez le lien, entrez le dans Google et ajoutez le bot AREA à votre server.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      areaTheme
                                          .backgroundContainer, // Fond coloré
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // Bord arrondi, // Bordure
                                ),
                                child: TextField(
                                  style: areaTheme.textWhite_16,
                                  controller: discordURLController,
                                  decoration: InputDecoration(
                                    hintText: discordURLController.text,
                                    hintStyle: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                    border:
                                        InputBorder
                                            .none, // Enlever la bordure du TextField
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                copyToClipboard(_url);
                                _pageController.nextPage(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ), // Durée de l'animation
                                  curve: Curves.easeInOut, // Courbe d'animation
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.bleu,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Copier",
                                style: areaTheme.textBoldWhite_18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: areaTheme.subSubGrey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text("Étape 3", style: areaTheme.textGrey_16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 380,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/Screencastfrom2024-11-0304-41-42-ezgif.com-video-to-gif-converter.gif?alt=media&token=1500a0c8-c016-4252-89c0-3b26be47f4ca",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Sélectionne et Copie ton identifiant Discord. Cet identifiant est ton 'DiscordID'",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color:
                                  areaTheme.backgroundContainer, // Fond coloré
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // Bord arrondi, // Bordure
                            ),
                            child: TextField(
                              style: areaTheme.textWhite_16,
                              controller: discordIDController,
                              decoration: const InputDecoration(
                                hintText: 'Votre Discord ID',
                                hintStyle: TextStyle(color: Colors.white54),
                                border:
                                    InputBorder
                                        .none, // Enlever la bordure du TextField
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10, // Positionné à droite du TextField
                            child: ElevatedButton(
                              onPressed: _pasteText,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.backgroundPage,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Coller",
                                style: areaTheme.textWhite_14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (discordIDController.text.isNotEmpty) {
                              goNextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: areaTheme.bleu,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Je continue',
                            style: areaTheme.textWhite_18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: areaTheme.subSubGrey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: Text("Étape 4", style: areaTheme.textGrey_16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Pour obtenir le channelId, accède au serveur, fais un clic droit sur le nom du salon voulu, puis sélectionne 'Copier l'identifiant'",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color:
                                  areaTheme.backgroundContainer, // Fond coloré
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // Bord arrondi, // Bordure
                            ),
                            child: TextField(
                              style: areaTheme.textWhite_16,
                              controller: channelIDController,
                              decoration: const InputDecoration(
                                hintText: 'Votre Channel ID',
                                hintStyle: TextStyle(color: Colors.white54),
                                border:
                                    InputBorder
                                        .none, // Enlever la bordure du TextField
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10, // Positionné à droite du TextField
                            child: ElevatedButton(
                              onPressed: _pasteText,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.backgroundPage,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Coller",
                                style: areaTheme.textWhite_14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (channelIDController.text.isNotEmpty) {
                              await discordApi.storeDiscordInfos(
                                discordIDController.text,
                                channelIDController.text,
                              );
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder:
                                    (
                                      context,
                                    ) => const ValidationCreateAreaBottomSheetWidget(
                                      message:
                                          "Votre service a été connecté avec succès",
                                    ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: areaTheme.bleu,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Connecter mon Discord',
                            style: areaTheme.textWhite_18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return DisconnectButtonWidget(serviceName: widget.serviceName);
        },
      ),
    );
  }
}
