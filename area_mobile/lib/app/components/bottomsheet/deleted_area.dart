import 'dart:async';

import 'package:area_mobile/backend/api/common/delete_area.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAreaBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String service;
  final String action;
  final List<String> reactions;
  const DeleteAreaBottomSheetWidget(
      {super.key,
      required this.service,
      required this.action,
      required this.reactions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => DeleteAreaBottomSheetWidgetState();
}

class DeleteAreaBottomSheetWidgetState
    extends State<DeleteAreaBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              child: Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: areaTheme.backgroundContainer,
                      borderRadius: BorderRadius.circular(40)),
                  child: Stack(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 80,
                              height: 3,
                              color: areaTheme.subGrey,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.clear,
                              size: 30,
                              color: areaTheme.red,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Souhaitez-vous supprimer cette Area ?",
                              style: areaTheme.textWhite_18,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: areaTheme.gr,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            14, 10, 14, 10),
                                    child: Text(
                                      "Fermer",
                                      style: areaTheme.textWhite_18,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    deleteArea(widget.service, widget.action,
                                        widget.reactions);
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: areaTheme.red,
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            14, 10, 14, 10),
                                    child: Text(
                                      "Supprimer",
                                      style: areaTheme.textWhite_18,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
