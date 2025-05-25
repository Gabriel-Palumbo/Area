import 'dart:async';
import 'dart:core';

import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/create_areas/create_areas_widget.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';

class CreateAreaBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const CreateAreaBottomSheetWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => CreateAreaBottomSheetWidgetState();
}

class CreateAreaBottomSheetWidgetState
    extends State<CreateAreaBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();

  late Future<List<Map<String, dynamic>>> futureServicesList;

  @override
  void initState() {
    super.initState();
    futureServicesList = fetchListServicesWithActionReaction();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: areaTheme.backgroundPage,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: AppBarWidget(
                    pageName: "Créer une Area",
                    showArrowLeft: true,
                  ),
                ),
                AreasCreationWidget()
              ],
            ))
        // const AreasCreationWidget()),
        );
  }
}
