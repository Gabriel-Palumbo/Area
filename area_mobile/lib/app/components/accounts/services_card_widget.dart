import 'package:area_mobile/app/components/bottomsheet/service_sign_bottomsheet.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceCardWidget extends StatefulWidget implements PreferredSizeWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;

  const ServiceCardWidget(
      {super.key, required this.serviceName, required this.serviceData});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => ServiceCardWidgetState();
}

class ServiceCardWidgetState extends State<ServiceCardWidget> {
  AreaTheme areaTheme = AreaTheme();

  void openBottomSheet(String serviceName, Map<String, dynamic> serviceData) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => ServiceSignBottomSheetWidget(
            serviceName: serviceName, serviceData: serviceData));
  }

  void refreshPage() {
    setState(() {}); // Appel setState pour forcer le rafraîchissement
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        openBottomSheet(widget.serviceName, widget.serviceData);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: areaTheme.backgroundContainer,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 8, 10),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: areaTheme.subSubGrey, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.network(
                    widget.serviceData['url'],
                    fit: BoxFit.contain,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 19, 19, 19),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Icon(
                      widget.serviceData['is_connected']
                          ? CupertinoIcons.check_mark
                          : CupertinoIcons.xmark,
                      size: 10,
                      color: widget.serviceData['is_connected']
                          ? areaTheme.green
                          : areaTheme.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Afficher le nom du service
              Text(
                widget.serviceName.toTitleCase(),
                style: areaTheme.textBoldWhite_18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
