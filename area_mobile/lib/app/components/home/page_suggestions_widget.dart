import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageSuggestionsWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const PageSuggestionsWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => PageSuggestionsWidgetState();
}

class PageSuggestionsWidgetState extends State<PageSuggestionsWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
          child: Text("Suggestions", style: areaTheme.textTitleWhiteBold),
        ),
        Row(
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: FilledButton(
                onPressed: () =>
                    navigationManager(context, "/actions", RouterTypes.go),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AreaTheme().backgroundContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    fixedSize: Size(130, 130)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: AssetImage('assets/images/new-area.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      "Nouvelle Area",
                      style: areaTheme.textWhite_14,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 130,
              height: 130,
              child: FilledButton(
                onPressed: () =>
                    navigationManager(context, "/account", RouterTypes.go),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AreaTheme().backgroundContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: SizedBox(
                        width: 40,
                        height: 50,
                        child: Image(
                          image: AssetImage('assets/images/account-area.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      "Vos comptes",
                      style: areaTheme.textWhite_14,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
