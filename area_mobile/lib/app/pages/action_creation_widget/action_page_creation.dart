import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/bottomsheet/create_areas_bottomsheet.dart';
import 'package:area_mobile/app/components/create_areas/list_area.dart';
import 'package:area_mobile/app/components/navbar_widget.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionPageWidget extends StatefulWidget implements PreferredSizeWidget {
  const ActionPageWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => ActionPageWidgetState();
}

class ActionPageWidgetState extends State<ActionPageWidget> {
  AreaTheme areaTheme = AreaTheme();

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const CreateAreaBottomSheetWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AreaTheme().backgroundPage,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: AppBarWidget(pageName: "Areas", showArrowLeft: false),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: Text(
                    "Vos actions",
                    style: areaTheme.textTitleGrey,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child:
                    ListAreaWidget(), // Ajout de ListAreaWidget dans SliverToBoxAdapter
              ),

              // const ListAreaWidget(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Créer une automatisation",
                      style: areaTheme.textWhite_26,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Automatisez vos services connectés en les liants les uns avec les autres. Choisissez l'action que vous souhaitez et liez là à une liste de réaction.",
                      style: areaTheme.textWhite_16,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () {
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
                            'Créer',
                            style: areaTheme.textBoldWhite_18,
                          ),
                          icon: const Icon(
                            CupertinoIcons.plus,
                            size: 20,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Align(alignment: Alignment.bottomCenter, child: NavBarWidget()),
        ],
      ),
    );
  }
}
