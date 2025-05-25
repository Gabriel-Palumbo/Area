import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/create_areas/reaction_widget.dart';
import 'package:area_mobile/app/components/create_areas/workflow_builder_widget.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';

class AreasCreationWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const AreasCreationWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => AreasCreationWidgetState();
}

class AreasCreationWidgetState extends State<AreasCreationWidget> {
  AreaTheme areaTheme = AreaTheme();

  final PageController _pageController = PageController();
  late Future<List<Map<String, dynamic>>> futureServicesList;

  String action = "f";
  String description = "f";
  String imgUrl = "f";
  String? serviceName;

  @override
  void initState() {
    super.initState();

    futureServicesList = fetchListServicesWithActionReaction();
  }

  void saveAction(String kaction, String kdescription, String kimgUrl) {
    goNextPage();

    setState(() {
      action = kaction;
      description = kdescription;
      imgUrl = kimgUrl;
    });
  }

  void goNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Contenu de la première page
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 10),
                child: Text(
                  "Sélectionnez une Action",
                  style: areaTheme.textTitleGrey,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: futureServicesList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Erreur lors du chargement'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Aucun service disponible'));
                      } else {
                        final services = snapshot.data!
                            .where((service) =>
                                service.values.first['is_connected'] == true)
                            .toList();

                        if (services.isEmpty) {
                          return const Center(
                              child: Text('Aucun service connecté'));
                        }

                        return Column(
                          children: List.generate(services.length, (index) {
                            final service = services[index];
                            final serviceName = service.keys.first;
                            final serviceData = service[serviceName];
                            final List<dynamic> actions =
                                serviceData["actions"];

                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...actions.map((action) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          this.serviceName = serviceName;
                                          saveAction(
                                            action['name'],
                                            action['description'],
                                            serviceData['url'],
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          backgroundColor:
                                              areaTheme.backgroundContainer,
                                          elevation: 0,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: areaTheme.subSubGrey,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.network(
                                                    serviceData['url'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Action',
                                                      style: areaTheme
                                                          .textBoldGrey_14,
                                                    ),
                                                    Text(
                                                      action['description']
                                                          .toString(),
                                                      style: areaTheme
                                                          .textWhite_18,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          }),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),

          // Autres pages du PageView
          ReactionWidget(
            actionID: serviceName,
            actionImgUrl: imgUrl,
            actionDescription: description,
            actionName: action,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
