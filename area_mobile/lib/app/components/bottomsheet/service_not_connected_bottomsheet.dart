import 'package:area_mobile/app/components/accounts/services_card_widget.dart';
import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/bottomsheet/service_sign_bottomsheet.dart';
import 'package:area_mobile/backend/global.dart';
import 'package:area_mobile/backend/models/services_model.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceNotConnectedBottomSheetWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final String serviceName;
  final Map<String, dynamic> serviceDetails;

  const ServiceNotConnectedBottomSheetWidget(
      {super.key, required this.serviceName, required this.serviceDetails});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() =>
      ServiceNotConnectedBottomSheetWidgetState();
}

class ServiceNotConnectedBottomSheetWidgetState
    extends State<ServiceNotConnectedBottomSheetWidget> {
  AreaTheme areaTheme = AreaTheme();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void openBottomSheet(String serviceName, Map<String, dynamic> serviceData) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => ServiceSignBottomSheetWidget(
            serviceName: serviceName, serviceData: serviceData));
    // refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        width: double.infinity,
        height: 380,
        decoration: BoxDecoration(
          color: areaTheme.backgroundContainer,
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
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 80,
                  height: 2,
                  color: areaTheme.subGrey,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Vous n'avez aucun compte ${widget.serviceName.toTitleCase()} de connecté. Si vous souhaitez utiliser ${widget.serviceName.toTitleCase()}, prenez le temps de vous connecter à avant de continuer l'intégration.",
                        style: areaTheme.textWhite_20,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: areaTheme.subGrey,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                child: ServiceCardWidget(
                  serviceName: widget.serviceName,
                  serviceData: widget.serviceDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      openBottomSheet(
                          widget.serviceName, widget.serviceDetails);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: areaTheme.bleu,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(
                            'Se connecter à ${widget.serviceName}',
                            style: areaTheme.textWhite_18,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
