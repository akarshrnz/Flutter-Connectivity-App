import 'package:flutter/material.dart';
import 'package:flutter_connectivity_app/core/config/route/app_route.dart';
import 'package:flutter_connectivity_app/core/utils/string_constants.dart';
import 'package:flutter_connectivity_app/di_injection.dart';
import 'package:flutter_connectivity_app/features/connection/presentation/bloc/connectivity_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependency();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(
          create: (_) => locator<ConnectivityBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        routerConfig: AppRoute.router,
      ),
    );
  }
}
