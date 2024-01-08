import 'package:flutter/material.dart';
import 'package:flutter_connectivity_app/features/connection/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        },
      ),
    ],
  );
}
