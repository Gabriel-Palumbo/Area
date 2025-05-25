import 'package:area_mobile/backend/api/common/disconnect_service.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/material.dart';

class DisconnectButtonWidget extends StatefulWidget {
  final String serviceName;
  const DisconnectButtonWidget({super.key, required this.serviceName});

  @override
  State<StatefulWidget> createState() => DisconnectButtonWidgetState();
}

class DisconnectButtonWidgetState extends State<DisconnectButtonWidget> {
  AreaTheme areaTheme = AreaTheme();

  // Function to make a POST request to store the GitHub token
  bool isLoading = false;
  String selectedRepo = '';
  List<String> repositories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // ! Appeler la fonction de déconnexion
                await disconnectServices(widget.serviceName.toLowerCase());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: areaTheme.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.white,
              ),
              child: Text('Se déconnecter', style: areaTheme.textWhiteBold_16),
            ),
          ),
        ],
      ),
    );
  }
}
