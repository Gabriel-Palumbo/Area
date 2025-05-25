import 'package:area_mobile/app/components/bottomsheet/deleted_area.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';

class ListAreaWidget extends StatefulWidget implements PreferredSizeWidget {
  const ListAreaWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => ListAreaWidgetState();
}

class ListAreaWidgetState extends State<ListAreaWidget> {
  AreaTheme areaTheme = AreaTheme();

  late Future<List<Map<String, dynamic>>> futureServicesList;

  @override
  void initState() {
    super.initState();
    futureServicesList = fetchListServicesWithActionReactionConnected();
  }

  void openBottomSheet(String service, String action, List<dynamic> reactions) {
    List<String> react = [];
    reactions.forEach((action) {
      react.add(action["reaction"]);
    });

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => DeleteAreaBottomSheetWidget(
              service: service,
              action: action,
              reactions: react,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: futureServicesList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erreur lors du chargement'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Rien par ici... Créez votre premier Workflow!'));
            } else {
              final services = snapshot.data!.toList();

              if (services.isEmpty) {
                return const Center(child: Text('Aucun service connecté'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 185),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final serviceAction = service['action'];
                  final serviceService = service['service'];
                  final serviceDescription = service['description'];
                  final serviceUrl = service['url'];
                  final List<dynamic> reactions = service['reactions'];

                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            openBottomSheet(
                                serviceService, serviceAction, reactions);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: areaTheme.backgroundContainer,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: null,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: areaTheme.subSubGrey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Image.network(
                                                serviceUrl,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Action',
                                                    style: areaTheme
                                                        .textBoldGrey_14),
                                                Text(
                                                  serviceDescription.toString(),
                                                  style: areaTheme.textWhite_18,
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
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: areaTheme.subGrey,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: reactions.length,
                                    itemBuilder: (context, actionIndex) {
                                      final reaction = reactions[actionIndex];
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 0, 15, 0),
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: null,
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                backgroundColor: areaTheme.gr,
                                                elevation: 0,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16)),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Container(
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                          color: areaTheme
                                                              .subSubGrey,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Image.network(
                                                          reaction['imageUrl'],
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 10, 10, 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Réaction ${actionIndex + 1}',
                                                              style: areaTheme
                                                                  .textBoldGrey_14),
                                                          Text(
                                                            reaction[
                                                                    'description']
                                                                .toString(),
                                                            style: areaTheme
                                                                .textWhite_16,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 2,
                                              height: 12,
                                              color: areaTheme.gr,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  // const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }
}
