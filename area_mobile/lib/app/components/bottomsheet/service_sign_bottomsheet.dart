import 'package:area_mobile/app/components/accounts/services_card_widget.dart';
import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/backend/models/services_model.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';

class ServiceSignBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String serviceName;
  final Map<String, dynamic> serviceData;

  const ServiceSignBottomSheetWidget(
      {super.key, required this.serviceName, required this.serviceData});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => ServiceSignBottomSheetWidgetState();
}

Widget getSignUpWidget(String serviceName, dynamic serviceData) {
  final widgetBuilder = serviceWidgets[serviceName.toLowerCase()];
  if (widgetBuilder != null) {
    return widgetBuilder(serviceName, serviceData);
  } else {
    throw Exception('Service not supported: $serviceName');
  }
}

class ServiceSignBottomSheetWidgetState
    extends State<ServiceSignBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: AppBarWidget(
                  pageName: widget.serviceName.toTitleCase(),
                  showArrowLeft: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ServiceCardWidget(
                    serviceName: widget.serviceName,
                    serviceData: widget.serviceData,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Builder(builder: (context) {
                print("🚀🚀🚀🚀🚀🚀 GET SIGN UP: ${widget.serviceName}");
                return getSignUpWidget(widget.serviceName, widget.serviceData);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
