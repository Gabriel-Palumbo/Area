import 'package:area_mobile/app/components/accounts/services_card_widget.dart';
import 'package:area_mobile/app/components/bottomsheet/service_sign_bottomsheet.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/backend/models/services_model.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:area_mobile/utils/title_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicServiceListViewWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const DynamicServiceListViewWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => DynamicServiceListViewWidgetState();
}

class DynamicServiceListViewWidgetState
    extends State<DynamicServiceListViewWidget> {
  AreaTheme areaTheme = AreaTheme();
  late Future<List<Map<String, dynamic>>> futureServicesList;

  @override
  void initState() {
    super.initState();
    futureServicesList = fetchListServicesConnectionOnly();
  }

  void openBottomSheet(String serviceName, Map<String, dynamic> serviceData) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => ServiceSignBottomSheetWidget(
            serviceName: serviceName, serviceData: serviceData));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Text("Vos comptes", style: areaTheme.textTitleWhiteBold),
          ),
          SizedBox(
            height: 100,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureServicesList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erreur lors du chargement'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun service disponible'));
                } else {
                  final services = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final serviceName = service.keys.first;
                      final serviceData = service[serviceName];

                      return Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // ! Appeler la fonction de open btm sheet
                                openBottomSheet(serviceName, serviceData);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                foregroundColor: Colors.transparent,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: areaTheme.backgroundContainer,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Image.network(
                                    serviceData[
                                        'url'], // Utiliser l'URL de l'image du service
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                  ),
                                  if (serviceData['is_connected'])
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 45, 45, 0),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff202020),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.check_mark,
                                          color: areaTheme.green,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                serviceName.toTitleCase(),
                                style: areaTheme.textBoldGrey_14,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
