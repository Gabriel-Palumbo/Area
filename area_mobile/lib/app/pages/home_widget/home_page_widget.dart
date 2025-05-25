import 'package:area_mobile/app/components/home/home_appbar_widget.dart';
import 'package:area_mobile/app/components/home/last_area_widget.dart';
import 'package:area_mobile/app/components/navbar_widget.dart';
import 'package:area_mobile/app/components/home/search_bar_widget.dart';
import 'package:area_mobile/app/components/home/page_suggestions_widget.dart';
import 'package:area_mobile/app/components/home/services_list_widget.dart';
import 'package:area_mobile/backend/google_auth.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<StatefulWidget> createState() => HomePageMapPageWidgetState();
}

class HomePageMapPageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AreaTheme().backgroundPage,
      // bottomNavigationBar: const NavBarWidget(),
      appBar: const AppBarHomeWidget(),
      body: const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                      child: SearchBarWidget(),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                      child: PageSuggestionsWidget(),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                      child: DynamicServiceListViewWidget(),
                    ),
                    LastAreaWidget()
                  ],
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: NavBarWidget()),
            ],
          )),
    );
  }
}
