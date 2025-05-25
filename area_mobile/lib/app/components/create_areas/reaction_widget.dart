import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/bottomsheet/validation_create_area.dart';
import 'package:area_mobile/app/components/create_areas/workflow_builder_widget.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/backend/api/common/save_action_reaction.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';

class ReactionWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? actionID;
  final String actionName;
  final String actionDescription;
  final String actionImgUrl;
  const ReactionWidget(
      {super.key,
      this.actionID,
      required this.actionName,
      required this.actionDescription,
      required this.actionImgUrl});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => ReactionWidgetState();
}

class reactionModel {
  final String reactionID;
  final String imgUrl;
  final String reaction;
  final String reactionDescription;

  reactionModel(
      {required this.reactionID,
      required this.reaction,
      required this.reactionDescription,
      required this.imgUrl});
}

class ReactionWidgetState extends State<ReactionWidget> {
  AreaTheme areaTheme = AreaTheme();

  final PageController _pageController = PageController();
  late Future<List<Map<String, dynamic>>> futureServicesList;

  List<reactionModel>? listReaction = [];

  @override
  void initState() {
    super.initState();

    futureServicesList = fetchListServicesWithActionReaction();
  }

  void saveReaction(String kreaction, String kreactionDescription,
      String kimgUrl, String reactionID) {
    setState(() {
      listReaction!.add(reactionModel(
          reactionID: reactionID,
          imgUrl: kimgUrl,
          reactionDescription: kreactionDescription,
          reaction: kreaction));
    });
  }

  void listReactionRemoveItem(int index) {
    setState(() {
      listReaction!.removeAt(index);
    });
  }

  void goNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void callSave() async {
    List<String> listReactionName = [];
    listReaction!.forEach((action) {
      String joinName = '${action.reactionID}/${action.reaction}';
      listReactionName.add(joinName);
    });
    saveActionReaction(widget.actionID!, widget.actionName, listReactionName);
  }

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const ValidationCreateAreaBottomSheetWidget(
              message: "Votre Area a été créé avec succès",
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (listReaction!.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  callSave();
                  Navigator.of(context).pop();
                  openBottomSheet();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: areaTheme.bleu,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                label: Text(
                  "Créer l'AREA",
                  style: areaTheme.textBoldWhite_18,
                ),
              ),
            ),
          ),
        WorkflowBuilingWidget(
          actionName: widget.actionName,
          actionDescription: widget.actionDescription,
          actionImgUrl: widget.actionImgUrl,
          listReaction: listReaction,
          listReactionLenght: listReaction!.length + 1,
          listReactionRemoveItem: listReactionRemoveItem,
        ),
        Container(
          width: double.infinity,
          height: 3,
          color: areaTheme.backgroundContainer,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
          child: Text(
            "Choisissez une ou plusieurs réactions",
            style: areaTheme.textTitleGrey,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureServicesList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erreur lors du chargement'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun service disponible'));
              } else {
                final services = snapshot.data!
                    .where((service) =>
                        service.values.first['is_connected'] == true)
                    .toList();

                if (services.isEmpty) {
                  return const Center(child: Text('Aucun service connecté'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 185), // Espace pour le bouton fixe en bas
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final serviceName = service.keys.first;
                    final serviceData = service[serviceName];
                    final List<dynamic> reactions = serviceData["reactions"];

                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reactions.length,
                            itemBuilder: (context, actionIndex) {
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    saveReaction(
                                        reactions[actionIndex]['name']
                                            .toString(),
                                        reactions[actionIndex]['description']
                                            .toString(),
                                        serviceData['url'].toString(),
                                        serviceName);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor:
                                        areaTheme.backgroundContainer,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 10, 8, 10),
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
                                              serviceData['url'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Réaction',
                                                  style: areaTheme
                                                      .textBoldGrey_14),
                                              Text(
                                                reactions[actionIndex]
                                                        ['description']
                                                    .toString(),
                                                style: areaTheme.textWhite_18,
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
