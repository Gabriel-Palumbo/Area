import 'package:area_mobile/app/components/bottomsheet/service_sign_bottomsheet.dart';
import 'package:area_mobile/utils/area_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SearchBarWidget({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<StatefulWidget> createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  void openBottomSheet(String serviceName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ServiceSignBottomSheetWidget(
        serviceName: serviceName,
        serviceData: {}, // Ajoute les données du service ici si nécessaire
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AreaTheme().backgroundContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: () {
          showSearch(
            context: context,
            delegate: AreaSearchDelegate(
              openBottomSheetCallback: openBottomSheet,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(CupertinoIcons.search, color: AreaTheme().subGrey),
            const SizedBox(width: 8),
            Text(
              "Quels outils?",
              style: AreaTheme().textGrey_16,
            ),
          ],
        ),
      ),
    );
  }
}

class AreaSearchDelegate extends SearchDelegate {
  final AreaTheme areaTheme = AreaTheme();
  final Function(String) openBottomSheetCallback;

  AreaSearchDelegate({required this.openBottomSheetCallback});

  List<String> searchTerms = [
    'Github',
    'Slack',
    'Trello',
    'Stripe',
    'GMail',
    'Dropbox',
    'Twilio',
    'Mailchimp',
    'PayPal',
    'Intercom',
    'Typeform',
    'Zoom',
    'Spotify',
    'Shopify'
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: areaTheme.backgroundContainer,
        iconTheme: IconThemeData(color: areaTheme.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        toolbarTextStyle: TextStyle(color: areaTheme.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: areaTheme.textGrey_20,
        border: InputBorder.none,
        filled: true,
        fillColor: areaTheme.backgroundContainer,
        labelStyle: TextStyle(color: areaTheme.white),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        bodyLarge: areaTheme.textWhite_16,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(CupertinoIcons.clear, color: Colors.white),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var service in searchTerms) {
      if (service.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(service);
      }
    }
    return Container(
      color: areaTheme.backgroundContainer,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result,
              style: TextStyle(color: areaTheme.white),
            ),
            onTap: () {
              close(context, null); // Ferme le search bar
              openBottomSheetCallback(
                  result.toLowerCase()); // Appelle le BottomSheet
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var service in searchTerms) {
      if (service.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(service);
      }
    }
    return Container(
      color: areaTheme.backgroundContainer,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(
              result,
              style: TextStyle(color: areaTheme.white),
            ),
            onTap: () {
              query = result;
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
