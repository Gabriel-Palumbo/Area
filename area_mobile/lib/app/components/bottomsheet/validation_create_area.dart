import 'dart:async';

import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValidationCreateAreaBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String message;
  const ValidationCreateAreaBottomSheetWidget(
      {super.key, required this.message});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() =>
      ValidationCreateAreaBottomSheetWidgetState();
}

class ValidationCreateAreaBottomSheetWidgetState
    extends State<ValidationCreateAreaBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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
                              CupertinoIcons.check_mark,
                              size: 30,
                              color: areaTheme.bleu,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.message,
                              style: areaTheme.textWhite_18,
                            ),
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
