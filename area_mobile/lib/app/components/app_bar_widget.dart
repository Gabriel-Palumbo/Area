import 'dart:ffi' as ffi;

import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String pageName;
  final bool showArrowLeft;

  const AppBarWidget(
      {super.key, required this.pageName, required this.showArrowLeft});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),

            widget.showArrowLeft == true
                ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                : SizedBox(),
            // SizedBox(
            //   height: 8,
            // ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Text(
                widget.pageName,
                style: areaTheme.textAppBarAreaLogo,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
