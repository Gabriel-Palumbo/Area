import 'dart:convert';

import 'package:area_mobile/app/components/disconnect_button.dart';
import 'package:area_mobile/backend/api/services/github_api.dart';
import 'package:area_mobile/backend/api/services/spotify_api.dart';
import 'package:area_mobile/backend/get_stored_token.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class SpotifySignUpWidget extends StatefulWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;
  const SpotifySignUpWidget({
    super.key,
    required this.serviceName,
    required this.serviceData,
  });

  @override
  State<StatefulWidget> createState() => SpotifySignUpWidgetState();
}

class SpotifySignUpWidgetState extends State<SpotifySignUpWidget> {
  AreaTheme areaTheme = AreaTheme();

  // Function to make a POST request to store the GitHub token
  final TextEditingController spotifyIDController = TextEditingController();
  final TextEditingController spotifyClientSecretController =
      TextEditingController();
  final PageController _pageController = PageController();
  bool isLoading = false;
  String selectedRepo = '';
  List<String> repositories = [];
  late SpotifyApi spotifyApi;
  late VideoPlayerController _controller;

  SpotifyApi setSpotifyApi() {
    final tokenAuth = getStoredToken();
    return SpotifyApi('Bearer $tokenAuth');
  }

  @override
  void initState() {
    super.initState();
    spotifyApi = setSpotifyApi();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/video-spotify.mp4?alt=media&token=545b1dbe-9de0-4bba-960f-0c86178fd9de',
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          })
          ..setLooping(true);
  }

  void _pasteText() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      spotifyIDController.text = data.text!;
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
                            "Bientôt disponible !",
                            style: areaTheme.textWhite_20,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: areaTheme.blackGrey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Fermer',
                                style: areaTheme.textBoldWhite_18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
