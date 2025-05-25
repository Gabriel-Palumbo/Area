import 'package:area_mobile/app/components/accounts/services_card_widget.dart';
import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/backend/google_auth.dart';
import 'package:area_mobile/backend/models/services_model.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const SettingsBottomSheetWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => SettingsBottomSheetWidgetState();
}

class SettingsBottomSheetWidgetState extends State<SettingsBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();
  String name = "Yanis";
  String lastname = "Lazreq";
  String email = "lazreqyanis@gmail.com";
  String? baseURL;
  bool isLocalhost = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setBaseURL();
    getUserInfo();
  }

  void setBaseURL() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    this.baseURL = await secureStorage.read(key: 'baseURL');
    if (baseURL == serverURL) {
      setState(() {
        isLocalhost = false;
      });
    } else {
      setState(() {
        isLocalhost = true;
      });
    }
  }

  void getUserInfo() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: areaTheme.backgroundContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Compte",
                      style: areaTheme.textWhite_26,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: areaTheme.blackGrey, shape: BoxShape.circle),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/tiens.jpg?alt=media&token=86200a85-98d8-4b88-afbd-a81ffa2de615', // Remplacez par le chemin de votre image
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: areaTheme.subGrey,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Prénom", style: areaTheme.textGrey_16),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12)),
                                      border: Border.all(
                                          color: areaTheme.subGrey,
                                          width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            name,
                                            style: areaTheme.textWhite_18,
                                          ),
                                        ],
                                      ),
                                    )),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nom", style: areaTheme.textGrey_16),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12)),
                                      border: Border.all(
                                          color: areaTheme.subGrey,
                                          width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            lastname,
                                            style: areaTheme.textWhite_18,
                                          ),
                                        ],
                                      ),
                                    )),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Email", style: areaTheme.textGrey_16),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: areaTheme.subGrey,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              email,
                              style: areaTheme.textWhite_18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      // ! Appeler la fonction de déconnexion
                      await secureStorage.write(key: 'auth_token', value: "");
                      navigationManager(context, "/onboarding", RouterTypes.go);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Se déconnecter',
                        style: areaTheme.textWhiteBold_16),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: areaTheme.subGrey,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                child: Text(
                  "Paramètres",
                  style: areaTheme.textWhite_26,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (context) {
                          print(
                              "🇺🇳🇺🇳🇺🇳 $baseURL | 🇺🇳🇺🇳🇺🇳 $serverURL");
                          if (isLocalhost == true) {
                            return Text(
                              "Switch à Online",
                              style: areaTheme.textWhite_18,
                            );
                          }
                          return Text(
                            "Switch à Local",
                            style: areaTheme.textWhite_18,
                          );
                        }),
                        SizedBox(
                          width: 12,
                        ),
                        Switch(
                            value: isLocalhost,
                            onChanged: (value) {
                              changeBaseURL(value);
                              setState(() {
                                isLocalhost = value;
                              });
                              print("CKEAOKFDOAZKODKZAOKDOKZAOK: $isLocalhost");
                            })
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
