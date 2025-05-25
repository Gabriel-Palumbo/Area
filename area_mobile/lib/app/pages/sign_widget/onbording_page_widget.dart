import 'package:area_mobile/app/components/navbar_widget.dart';
import 'package:area_mobile/app/pages/sign_widget/login_page_widget.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnbordingWidget extends StatefulWidget implements PreferredSizeWidget {
  const OnbordingWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => OnbordingWidgetState();
}

class OnbordingWidgetState extends State<OnbordingWidget> {
  AreaTheme areaTheme = AreaTheme();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AreaTheme().backgroundPage,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/area-2-e77d3.appspot.com/o/tiens.jpg?alt=media&token=86200a85-98d8-4b88-afbd-a81ffa2de615")),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      navigationManager(context, "/signup", RouterTypes.push)
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: const Color(0xff131313),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Créer un compte",
                          style: areaTheme.textBoldWhite_18,
                        ),
                        const Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigationManager(context, "/login", RouterTypes.push);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: const Color(0xff131313),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Se connecter",
                          style: areaTheme.textBoldWhite_18,
                        ),
                        const Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
