import 'package:area_mobile/app/components/bottomsheet/settings_bottomsheet.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarHomeWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarHomeWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => AppBarHomeWidgetState();
}

class AppBarHomeWidgetState extends State<AppBarHomeWidget> {
  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const SettingsBottomSheetWidget());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("AREA", style: AreaTheme().textAppBarAreaLogo),
            SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  onPressed: () {
                    openBottomSheet();
                  },
                  // navigationManager(context, "/home", RouterTypes.go),
                  icon:
                      Icon(CupertinoIcons.settings, color: AreaTheme().subGrey),
                )),
          ],
        ),
      ),
    )

        // AppBar(
        //   backgroundColor: AreaTheme().backgroundPage,
        //   title: Text("AREA", style: AreaTheme().textAppBarAreaLogo),

        // ),
        );
  }
}
