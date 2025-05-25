import 'dart:async';
import 'package:area_mobile/app/components/app_bar_widget.dart';
import 'package:area_mobile/app/components/navbar_widget.dart';
import 'package:area_mobile/app/components/accounts/services_card_widget.dart';
import 'package:area_mobile/backend/api/common/get_list_services_api.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';

class AccountPageWidget extends StatefulWidget implements PreferredSizeWidget {
  const AccountPageWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => AccountPageWidgetState();
}

class AccountPageWidgetState extends State<AccountPageWidget> {
  AreaTheme areaTheme = AreaTheme();

  late Future<List<Map<String, dynamic>>> futureServicesList;
  // late Timer timer;

  @override
  void initState() {
    super.initState();

    // Récupération des services via l'API
    futureServicesList = toto();
    // timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
    //   setState(() {
    //     futureServicesList = toto();
    //   });
    // });
  }

  void dispose() {
    // Arrête le timer lorsque le widget est supprimé
    // timer.cancel();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> toto() async {
    return await fetchListServicesWithActionReaction();
  }

  // Fonction pour séparer les services connectés et déconnectés
  Map<String, List<Map<String, dynamic>>> categorizeServices(
      List<Map<String, dynamic>> services) {
    final connectedServices = services
        .where((service) => service.values.first['is_connected'] == true)
        .toList();
    final disconnectedServices = services
        .where((service) => service.values.first['is_connected'] == false)
        .toList();
    return {
      'connected': connectedServices,
      'disconnected': disconnectedServices,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AreaTheme().backgroundPage,
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureServicesList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load services'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No services available'));
              } else {
                final categorizedServices = categorizeServices(snapshot.data!);
                final connectedServices = categorizedServices['connected']!;
                final disconnectedServices =
                    categorizedServices['disconnected']!;

                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: AppBarWidget(
                            pageName: "Vos comptes", showArrowLeft: false),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                        child: Text(
                          "Connectés",
                          style: areaTheme.textTitleGrey,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5 / 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final service = connectedServices[index];
                            final serviceName = service.keys.first;
                            final serviceData = service[serviceName];

                            return ServiceCardWidget(
                              serviceName: serviceName,
                              serviceData: serviceData,
                            );
                          },
                          childCount: connectedServices.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                        child: Text(
                          "Déconnectés",
                          style: areaTheme.textTitleGrey,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5 / 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final service = disconnectedServices[index];
                            final serviceName = service.keys.first;
                            final serviceData = service[serviceName];

                            return ServiceCardWidget(
                              serviceName: serviceName,
                              serviceData: serviceData,
                            );
                          },
                          childCount: disconnectedServices.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const Align(alignment: Alignment.bottomCenter, child: NavBarWidget()),
        ],
      ),
    );
  }
}
