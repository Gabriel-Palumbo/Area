import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/create_areas/create_areas_widget.dart';
import 'package:area_mobile/app/components/create_areas/reaction_widget.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';

class WorkflowBuilingWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String actionName;
  final String actionDescription;
  final String actionImgUrl;
  final int listReactionLenght;
  final List<reactionModel>? listReaction;
  final Function listReactionRemoveItem;
  const WorkflowBuilingWidget(
      {super.key,
      required this.actionName,
      required this.actionDescription,
      required this.actionImgUrl,
      required this.listReactionLenght,
      this.listReaction,
      required this.listReactionRemoveItem});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => WorkflowBuilingWidgetState();
}

class WorkflowBuilingWidgetState extends State<WorkflowBuilingWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 230, // Hauteur maximale de 300
        ),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Workflow", style: areaTheme.textWhite_26),
                              Text((widget.listReactionLenght.toString()),
                                  style: areaTheme.textWhite_26),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: areaTheme.backgroundContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 10, 8, 10),
                                  child: Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: areaTheme.subSubGrey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.network(
                                          widget.actionImgUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Action',
                                            style: areaTheme.textBoldGrey_14),
                                        Text(
                                          widget.actionDescription
                                              .toString()
                                              .toTitleCase(),
                                          style: areaTheme.textWhite_16,
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
                        ],
                      ),
                      Center(
                        child: Container(
                          width: 3,
                          height: 14,
                          color: areaTheme.backgroundContainer,
                        ),
                      ),
                      FutureBuilder<List<reactionModel>>(
                        future: Future.value(
                            widget.listReaction), // Simule un Future ici
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Erreur lors du chargement'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                              child: Text('Rajouter une reaction'),
                            ));
                          } else {
                            final reactions = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reactions.length,
                              itemBuilder: (context, index) {
                                final reaction = reactions[index];

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 0, 20, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            widget
                                                .listReactionRemoveItem(index);
                                          });
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
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(8, 10, 8, 10),
                                              child: Container(
                                                width: 40,
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
                                                    reaction.imgUrl,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 10, 4, 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Réaction ${index + 1}',
                                                        style: areaTheme
                                                            .textBoldGrey_14),
                                                    Text(
                                                      reaction
                                                          .reactionDescription,
                                                      style: areaTheme
                                                          .textWhite_16,
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
                                      Center(
                                        child: Container(
                                          width: 3,
                                          height: 12,
                                          color: areaTheme.backgroundContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
