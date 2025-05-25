import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/services/telegram_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class TelegramSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const TelegramSignUpWidget(
      {super.key, required this.serviceName, required this.serviceData});

  @override
  State<StatefulWidget> createState() => TelegramSignUpWidgetState();
}

class TelegramSignUpWidgetState extends State<TelegramSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  final TextEditingController telegramIDController = TextEditingController();
  final TextEditingController telegramBOTController = TextEditingController();

  final PageController _pageController = PageController();
  bool isLoading = false;
  late TelegramApi telegramApi;
  late VideoPlayerController _controller;

  TelegramApi setTelegramApi() {
    final tokenAuth = getStoredToken();
    return TelegramApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    telegramApi = setTelegramApi();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/video-telegram.mp4?alt=media&token=6757ae96-df95-4b9a-ba72-485e77a45750'),
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
    telegramBOTController.text = "area_allo_poulet_bot";
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      telegramIDController.text = data.text!;
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: areaTheme.backgroundPage),
        child: Builder(builder: (context) {
          if (widget.serviceData['is_connected'] == false) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                              color: areaTheme.blackGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          clipBehavior: Clip.antiAlias,
                          child: _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Suivez les étapes pour vous connecter à Telegram afin d’être informé des événements de votre Bot.",
                          style: areaTheme.textWhite_20,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              goNextPage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: areaTheme.bleu,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Continuer',
                              style: areaTheme.textBoldWhite_18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        child: Center(
                          child: Text(
                            "Étape 1",
                            style: areaTheme.textGrey_16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recherchez le bot @userinfobot dans Telegram. Démarrez une conversation avec lui en cliquant sur Démarrer. Le bot vous répondra avec votre ID Telegram.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(
                                      milliseconds:
                                          300), // Durée de l'animation
                                  curve: Curves.easeInOut, // Courbe d'animation
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.bleu,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            color: areaTheme.subSubGrey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        child: Center(
                          child: Text(
                            "Étape 2",
                            style: areaTheme.textGrey_16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Entrez votre identifiant Telegram récupéré à l'étape précédente.",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                  15), // Bord arrondi, // Bordure
                            ),
                            child: TextField(
                              style: areaTheme.textWhite_16,
                              controller: telegramIDController,
                              decoration: const InputDecoration(
                                hintText: 'Votre Telegram ID',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                ),
                                border: InputBorder
                                    .none, // Enlever la bordure du TextField
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20.0),
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
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (telegramIDController.text.isNotEmpty) {
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
                // ! AJOUTER ICI
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        child: Center(
                          child: Text(
                            "Étape 3",
                            style: areaTheme.textGrey_16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Avant de terminer, veuillez ajouter à votre groupe telegram le bot et pinguez le (@area_allo_poulet_bot):",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                  15), // Bord arrondi, // Bordure
                            ),
                            child: TextField(
                              style: areaTheme.textWhite_16,
                              controller: telegramBOTController,
                              decoration: InputDecoration(
                                hintText: telegramBOTController.text,
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                border: InputBorder
                                    .none, // Enlever la bordure du TextField
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10, // Positionné à droite du TextField
                            child: ElevatedButton(
                              onPressed: () {
                                copyToClipboard("area_allo_poulet_bot");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.backgroundPage,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Copier",
                                style: areaTheme.textWhite_14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (telegramIDController.text.isNotEmpty) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: areaTheme.subSubGrey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                          child: Text(
                            "Étape 4",
                            style: areaTheme.textGrey_16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Pour finir, validez la connection de Telegram:",
                        style: areaTheme.textWhite_20,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await telegramApi.storeTelegramApiInfos(
                                telegramIDController.text);
                            Navigator.of(context).pop();
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) =>
                                    const ValidationCreateAreaBottomSheetWidget(
                                      message:
                                          "Votre service a été connecté avec succès",
                                    ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: areaTheme.bleu,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  'Connecter Telegram',
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
          return DisconnectButtonWidget(
            serviceName: widget.serviceName,
          );
        }));
  }
}
