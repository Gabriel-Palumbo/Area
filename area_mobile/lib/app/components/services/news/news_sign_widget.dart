import 'package:area_mobile/app/components/bottomsheet/service_not_connected_bottomsheet.dart';
import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/backend/api/services/news_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NewsSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const NewsSignUpWidget(
      {super.key, required this.serviceName, required this.serviceData});

  @override
  State<StatefulWidget> createState() => NewsSignUpWidgetState();
}

class NewsSignUpWidgetState extends State<NewsSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  bool isLoading = false;
  List<String> sujets = [
    'Sport',
    'Finance',
    'Santé',
    'Business',
    'Technologie'
  ];
  String? selectedSubject;
  List<String> messagerie = ['Telegram', 'Discord', 'Slack'];
  String? selectedMessagerie;
  final PageController _pageController = PageController();
  late VideoPlayerController _controller;
  late Future<List<Map<String, dynamic>>> futureServicesList;
  late NewsApi newsApi;
  NewsApi setNewsApi() {
    final tokenAuth = getStoredToken();
    return NewsApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/video-news.mp4?alt=media&token=75811f45-e712-46b1-8dc7-f6dcfc6895e5'),
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
    futureServicesList = fetchListServicesConnectionOnly();
    newsApi = setNewsApi();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void openBottomSheet(
      String serviceName, Map<String, dynamic> serviceDetails) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => ServiceNotConnectedBottomSheetWidget(
            serviceName: serviceName, serviceDetails: serviceDetails));
  }

  Future<void> processServicesList() async {
    try {
      List<Map<String, dynamic>> servicesList = await futureServicesList;

      for (Map<String, dynamic> serviceMap in servicesList) {
        serviceMap.forEach((serviceName, serviceDetails) {
          bool isConnected = serviceDetails['is_connected'] ?? false;
          String url = serviceDetails['url'] ?? '';
          if (serviceName == selectedMessagerie!.toLowerCase()) {
            if (isConnected == true) {
              goNextPage();
            } else {
              openBottomSheet(selectedMessagerie!, serviceDetails);
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching services list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 2,
        decoration: BoxDecoration(color: areaTheme.backgroundPage),
        child: Builder(builder: (context) {
          if (widget.serviceData['is_connected'] == false) {
            return PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Builder(builder: (context) {
                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                                color: areaTheme.bleu,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
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
                            "Recevez les dernières News sur le Sport, la finance, la santé, la technologie et le business.",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Activer News',
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
                                const BorderRadius.all(Radius.circular(100)),
                          ),
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
                        Text(
                          "Quel est votre sujet favori 💛 ?",
                          style: areaTheme.textWhite_20,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 60,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: areaTheme.backgroundContainer,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedSubject,
                                  hint: Text(
                                    'Sélectionner un sujet',
                                    style: areaTheme.textWhite_16,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white54,
                                  ),
                                  dropdownColor: areaTheme.backgroundContainer,
                                  isExpanded: true,
                                  items: sujets.map((String city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(
                                        city,
                                        style: areaTheme.textWhite_16,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSubject = newValue;
                                    });
                                  },
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
                              if (selectedSubject != null) {
                                goNextPage();
                              }
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
                                    'Continuer',
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
                              "Étape 2",
                              style: areaTheme.textGrey_16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Sélectionnez un service de messagerie",
                          style: areaTheme.textWhite_20,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 60,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: areaTheme.backgroundContainer,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedMessagerie,
                                  hint: Text(
                                    'Choisir une messagerie',
                                    style: areaTheme.textWhite_16,
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white54,
                                  ),
                                  dropdownColor: areaTheme.backgroundContainer,
                                  isExpanded: true,
                                  items: messagerie.map((String messagerie) {
                                    return DropdownMenuItem<String>(
                                      value: messagerie,
                                      child: Text(
                                        messagerie,
                                        style: areaTheme.textWhite_16,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMessagerie = newValue;
                                    });
                                  },
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
                              if (selectedMessagerie != null) {
                                processServicesList();
                              }
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
                                    'Continuer',
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
                              "Étape 3",
                              style: areaTheme.textGrey_16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Pour finir, validez la connection de News:",
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
                              await newsApi.storeNewsInfos(
                                  selectedSubject!, selectedMessagerie!);
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
                                    'Connecter News',
                                    style: areaTheme.textWhite_18,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
          }

          return DisconnectButtonWidget(
            serviceName: widget.serviceName,
          );
        }));
  }
}


