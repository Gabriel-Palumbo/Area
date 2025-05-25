import 'dart:convert';

import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/common/disconnect_service.dart';
import 'package:area_mobile/backend/api/services/github_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class GithubSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const GithubSignUpWidget({
    super.key,
    required this.serviceName,
    required this.serviceData,
  });

  @override
  State<StatefulWidget> createState() => GithubSignUpWidgetState();
}

class GithubSignUpWidgetState extends State<GithubSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  // Function to make a POST request to store the GitHub token
  final TextEditingController githubTokenController = TextEditingController();
  final PageController _pageController = PageController();
  bool isLoading = false;
  String selectedRepo = '';
  List<String> repositories = [];
  late VideoPlayerController _controller;

  late GithubApi githubApi;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/video-github.mp4?alt=media&token=74ac5c0b-af50-4218-bd81-b8f05ec659e7',
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          })
          ..setLooping(true);
    githubApi = setGithubApi();
  }

  GithubApi setGithubApi() {
    final tokenAuth = getStoredToken();
    return GithubApi('Bearer $tokenAuth');
  }

  Future<void> storeGithubToken() async {
    setState(() {
      isLoading = true;
    });

    await githubApi.storeGithubToken(
      githubTokenController.text,
      () async {
        await getGithubRepos(); // OnSuccess: Aller récupérer les repos
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          isLoading = false;
        });
      },
      (errorMessage) {
        print(errorMessage); // OnError: afficher l'erreur
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> getGithubRepos() async {
    await githubApi.getGithubRepos(
      (repos) {
        setState(() {
          repositories = repos;
        });
      },
      (errorMessage) {
        print(errorMessage); // Gérer l'erreur ici
      },
    );
  }

  Future<void> createWebhook() async {
    setState(() {
      isLoading = true;
    });

    await githubApi.createWebhook(
      selectedRepo,
      () {
        Navigator.of(context).pop(); // OnSuccess: fermer la page
        setState(() {
          isLoading = false;
        });
      },
      (errorMessage) {
        print(errorMessage); // Gérer l'erreur ici
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      githubTokenController.text = data.text!;
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
                // githubApi == null ? SizedBox() : goNextPage(),
                Builder(
                  builder: (context) {
                    if (githubApi == null) {
                      return SizedBox.expand();
                    }
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
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: areaTheme.blackGrey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child:
                                _controller.value.isInitialized
                                    ? AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    )
                                    : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Suivez les étapes pour connecter votre Github afin d’être informé des événements Git.",
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
                      Text(
                        "Entrez votre Token",
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
                              controller: githubTokenController,
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
                            if (githubTokenController.text.isNotEmpty) {
                              await storeGithubToken();
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
                                    'Connecter votre compte',
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
                      Text(
                        'Selectionnez le repo Github auquel vous souhaitez être connecté.',
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 12),
                      DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: areaTheme.backgroundContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        value: selectedRepo.isEmpty ? null : selectedRepo,
                        hint: Text(
                          'Selectionnez un repo',
                          style: areaTheme.textWhite_16,
                        ),
                        items:
                            repositories.map((repo) {
                              return DropdownMenuItem(
                                value: repo,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                    20,
                                    0,
                                    20,
                                    0,
                                  ),
                                  child: Text(
                                    repo,
                                    style: areaTheme.textWhite_16,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRepo = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedRepo.isNotEmpty) {
                              await createWebhook();
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
                            backgroundColor:
                                selectedRepo.isNotEmpty
                                    ? areaTheme.bleu
                                    : Colors.black,
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
                                    'Créer la connexion',
                                    style:
                                        selectedRepo.isNotEmpty
                                            ? areaTheme.textWhiteBold_16
                                            : areaTheme
                                                .textGrey_16, // Remplace avec areaTheme.textBoldWhite_18
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
