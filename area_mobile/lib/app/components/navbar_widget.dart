import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => NavBarWidgetState();
}

class NavBarWidgetState extends State<NavBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        width: 250,
        height: 60,
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          boxShadow: [
            BoxShadow(
                color: AreaTheme().navBar,
                offset: const Offset(0, 20),
                blurRadius: 20)
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: 36,
              height: 36,
              child: IconButton(
                onPressed: () =>
                    navigationManager(context, "/actions", RouterTypes.go),
                icon: const Icon(
                  CupertinoIcons.sparkles,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )),
          SizedBox(
              width: 36,
              height: 36,
              child: IconButton(
                onPressed: () =>
                    navigationManager(context, "/home", RouterTypes.go),
                icon: const Icon(
                  CupertinoIcons.home,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
                onPressed: () =>
                    navigationManager(context, "/account", RouterTypes.go),
                icon: const Icon(CupertinoIcons.person_crop_circle_fill,
                    color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ]),
      ),
    );
  }
}
