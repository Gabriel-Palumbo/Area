import 'dart:ffi';

import 'package:area_mobile/app/pages/account_widget/account_page_widget.dart';
import 'package:area_mobile/app/pages/action_creation_widget/action_page_creation.dart';
import 'package:area_mobile/app/pages/home_widget/home_page_widget.dart';
import 'package:area_mobile/app/pages/sign_widget/login_page_widget.dart';
import 'package:area_mobile/app/pages/sign_widget/onbording_page_widget.dart';
import 'package:area_mobile/app/pages/sign_widget/signup_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router =
    GoRouter(initialLocation: "/onboarding", routes: <RouteBase>[
  // Onboarding
  GoRoute(
    name: "/onboarding",
    path: "/onboarding",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const OnbordingWidget(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  ),

  GoRoute(
    name: "/login",
    path: "/login",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: LoginPage(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  ),

  GoRoute(
    name: "/signup",
    path: "/signup",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: SignupPage(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  ),

  // Home
  GoRoute(
    name: "/home",
    path: "/home",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const HomePageWidget(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  ),

  // Actions
  GoRoute(
    name: "/actions",
    path: "/actions",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ActionPageWidget(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  ),

  // Account page
  GoRoute(
    name: "/account",
    path: "/account",
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AccountPageWidget(),
        barrierDismissible: true,
        barrierColor: Colors.black38,
        opaque: false,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, Widget child) => child,
      );
    },
  )
]);

enum RouterTypes {
  go,
  push,
}

void navigationManager(BuildContext context, String routeName, RouterTypes r) {
  if (r == RouterTypes.go) {
    context.goNamed(routeName);
  } else if (r == RouterTypes.push) {
    context.pushNamed(routeName);
  }
}
