import 'dart:convert';

import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/services/github_api.dart';
import 'package:area_mobile/backend/api/services/slack_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class SlackSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const SlackSignUpWidget({
    super.key,
    required this.serviceName,
    required this.serviceData,
  });

  @override
  State<StatefulWidget> createState() => SlackSignUpWidgetState();
}

class SlackSignUpWidgetState extends State<SlackSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  // Function to make a POST request to store the GitHub token
  final TextEditingController slackMemberIDController = TextEditingController();
  final TextEditingController slackTokenController = TextEditingController();
  final PageController _pageController = PageController();
  bool isLoading = false;
  String selectedRepo = '';
  List<String> repositories = [];

  late SlackApi slackApi;

  SlackApi setSlackApi() {
    final tokenAuth = getStoredToken();
    return SlackApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    slackApi = setSlackApi();
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      slackMemberIDController.text = data.text!;
    }
  }

  void goNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
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
                            "Suivez les étapes pour connecter votre Slack.",
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
                // Première page avec le code donné
                // Deuxième page avec un titre
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
                        "Entrez votre ID de membre Slack",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 12),
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
                              controller: slackMemberIDController,
                              decoration: const InputDecoration(
                                hintText: 'ID de membre',
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
                            if (slackMemberIDController.text.isNotEmpty) {
                              // await storeGithubToken();
                              goNextPage();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: areaTheme.bleu,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                  : Text(
                                    'Suivant',
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
                          child: Text("Étape 2", style: areaTheme.textGrey_16),
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
                        "Pour terminer, entrez votre Token Slack.",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 12),
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
                              controller: slackTokenController,
                              decoration: const InputDecoration(
                                hintText: 'Token',
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
                            if (slackTokenController.text.isNotEmpty) {
                              await slackApi.storeSlackInfos(
                                slackTokenController.text,
                                slackMemberIDController.text,
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
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                  : Text(
                                    'Terminer',
                                    style: areaTheme.textWhite_18,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                // View 3: Success Confirmation
              ],
            );
          }
          return DisconnectButtonWidget(serviceName: widget.serviceName);
        },
      ),
    );
  }
}
