import 'package:area_mobile/app/components/bottomsheet/deleted_area.dart';
import 'package:area_mobile/backend/api/common/get_recent_event.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ListLastWorkflowWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const ListLastWorkflowWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => ListLastWorkflowWidgetState();
}

class ListLastWorkflowWidgetState extends State<ListLastWorkflowWidget> {
  AreaTheme areaTheme = AreaTheme();
  late Future<List<Map<String, dynamic>>> futureServicesEvent;
  DateFormat format = DateFormat("dd MMMM - HH'h'mm");

  @override
  void initState() {
    super.initState();
    futureServicesEvent = getRecentEvent();
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
          future: futureServicesEvent,
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
                return const Center(
                    child:
                        Text('Rien par ici...\nCréez votre premier Workflow!'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 185),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final serviceDescription = service['description'];
                  final serviceUrl = service['url'];
                  final serviceTimeInSec = service['createdAt']['seconds'];
                  final serviceUserId = service['userId'];

                  print("🎯🎯🎯🎯 $serviceTimeInSec");
                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      serviceTimeInSec * 1000);
                  String formattedDate = format.format(dateTime);

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: areaTheme.backgroundContainer,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                                ElevatedButton(
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Image.network(
                                                  serviceUrl,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(formattedDate.toString(),
                                                      style: areaTheme
                                                          .textBoldGrey_14),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    serviceDescription
                                                        .toString(),
                                                    style:
                                                        areaTheme.textWhite_18,
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
                                      Container(
                                        width: double.infinity,
                                        height: 2,
                                        color: areaTheme.subGrey,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: areaTheme.blackGrey,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 8, 8, 12),
                                          child: Text(serviceUserId,
                                              style: areaTheme.textBoldGrey_14),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
          height: 50,
        )
      ],
    );
  }
}
