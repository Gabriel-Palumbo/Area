// Définis un map entre les noms de service et les widgets
import 'package:area_mobile/app/components/services/coinmarketcap/coinmarketcap_sign_widget.dart';
import 'package:area_mobile/app/components/services/discord/discord_sign_widget.dart';
import 'package:area_mobile/app/components/services/football/football_sign_widget.dart';
import 'package:area_mobile/app/components/services/github/github_sign_widget.dart';
import 'package:area_mobile/app/components/services/gmail/gmail_sign_widget.dart';
import 'package:area_mobile/app/components/services/googlemap/googlemap_sign_widget.dart';
import 'package:area_mobile/app/components/services/sotcks/stocks_sign_widget.dart';
import 'package:area_mobile/app/components/services/news/news_sign_widget.dart';
import 'package:area_mobile/app/components/services/quotes/quotes_sign_widget.dart';
import 'package:area_mobile/app/components/services/shopify/shopify_sign_widget.dart';
import 'package:area_mobile/app/components/services/slack/slack_sign_widget.dart';
import 'package:area_mobile/app/components/services/spotify/spotify_sign_widget.dart';
import 'package:area_mobile/app/components/services/telegram/telegram_widget.dart';
import 'package:area_mobile/app/components/services/time/time_sign_widget.dart';
import 'package:area_mobile/app/components/services/weather/weather_sign_widget.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(String, dynamic)> serviceWidgets = {
  'github': (serviceName, serviceData) =>
      GithubSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'discord': (serviceName, serviceData) =>
      DiscordSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'slack': (serviceName, serviceData) =>
      SlackSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'spotify': (serviceName, serviceData) =>
      SpotifySignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'gmail': (serviceName, serviceData) =>
      GmailSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'shopify': (serviceName, serviceData) =>
      ShopifySignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'coincap': (serviceName, serviceData) => CoinMarketCapSignUpWidget(
      serviceName: serviceName, serviceData: serviceData),
  'news': (serviceName, serviceData) =>
      NewsSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'weather': (serviceName, serviceData) =>
      WeatherSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'quotes': (serviceName, serviceData) =>
      QuotesSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'football': (serviceName, serviceData) =>
      FootballSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'time': (serviceName, serviceData) =>
      TimeSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'telegram': (serviceName, serviceData) =>
      TelegramSignUpWidget(serviceName: serviceName, serviceData: serviceData),
  'stocks': (serviceName, serviceData) =>
      StockSignWidget(serviceName: serviceName, serviceData: serviceData),
  'googlemap': (serviceName, serviceData) =>
      GoogleMapSignUpWidget(serviceName: serviceName, serviceData: serviceData),
};
