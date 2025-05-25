import 'dart:async';

import 'package:area_mobile/app/components/bottomsheet/service_not_connected_bottomsheet.dart';
import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/backend/api/services/googlemap_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

class GoogleMapSignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const GoogleMapSignUpWidget(
      {super.key, required this.serviceName, required this.serviceData});

  @override
  State<StatefulWidget> createState() => GoogleMapSignUpWidgetState();
}

class GoogleMapSignUpWidgetState extends State<GoogleMapSignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  bool isLoading = false;
  String? selectedSubject;
  List<String> messagerie = ['Telegram', 'Discord', 'Slack'];
  String? selectedMessagerie;
  final PageController _pageController = PageController();
  final Completer<GoogleMapController> _googleController =
      Completer<GoogleMapController>();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController apikeyController = TextEditingController();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late VideoPlayerController _controller;
  late Future<List<Map<String, dynamic>>> futureServicesList;
  late GoogleMapApi googleMapApi;
  GoogleMapApi setGoogleMapApi() {
    final tokenAuth = getStoredToken();
    return GoogleMapApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/video-googlemap.mp4?alt=media&token=089a0361-3de2-4e82-af41-a6aeab81f6f2'),
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
    futureServicesList = fetchListServicesConnectionOnly();
    googleMapApi = setGoogleMapApi();
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

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      originController.text = data.text!;
    }
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // Ajuste le rayon ici
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: areaTheme.bleu,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              clipBehavior: Clip.antiAlias,
                              child: _controller.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Recevez des informations de trafic sur votre trajet.",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.dispose();
                                goNextPage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.bleu,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Activer Google Maps',
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
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          clipBehavior: Clip
                              .hardEdge, // Active le clipping sur le Container
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // Applique le même rayon ici
                            child: const GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: _kGooglePlex,
                              myLocationEnabled: false, // Désactive MyLocation
                              myLocationButtonEnabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Entrez votre adresse de départ:",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: areaTheme
                                    .backgroundContainer, // Fond coloré
                                borderRadius: BorderRadius.circular(
                                    15), // Bord arrondi, // Bordure
                              ),
                              child: TextField(
                                style: areaTheme.textWhite_16,
                                controller: originController,
                                decoration: const InputDecoration(
                                  hintText: 'Adresse départ',
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
                              if (originController.text.isNotEmpty) {
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
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          clipBehavior: Clip
                              .hardEdge, // Active le clipping sur le Container
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20.0), // Applique le même rayon ici
                            child: const GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: _kGooglePlex,
                              myLocationEnabled: false, // Désactive MyLocation
                              myLocationButtonEnabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Entrez votre adresse de destination:",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: areaTheme
                                    .backgroundContainer, // Fond coloré
                                borderRadius: BorderRadius.circular(
                                    15), // Bord arrondi, // Bordure
                              ),
                              child: TextField(
                                style: areaTheme.textWhite_16,
                                controller: destinationController,
                                decoration: const InputDecoration(
                                  hintText: "Adresse destination",
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
                              if (destinationController.text.isNotEmpty) {
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100))),
                          child: Center(
                            child: Text(
                              "Étape 4",
                              style: areaTheme.textGrey_16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Entrez votre clé API Google Map",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: areaTheme
                                    .backgroundContainer, // Fond coloré
                                borderRadius: BorderRadius.circular(
                                    15), // Bord arrondi, // Bordure
                              ),
                              child: TextField(
                                style: areaTheme.textWhite_16,
                                controller: apikeyController,
                                decoration: const InputDecoration(
                                  hintText: "Clé API",
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
                              if (apikeyController.text.isNotEmpty) {
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
                              "Étape 5",
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
                                  icon: const Icon(
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
                              "Étape 6",
                              style: areaTheme.textGrey_16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Pour finir, validez la connection de Google Map:",
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
                              await googleMapApi.storeGoogleMapInfos(
                                  selectedMessagerie!,
                                  originController.text,
                                  destinationController.text,
                                  apikeyController.text);
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
                                    'Connecter Google Map',
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
