import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_connectivity_app/core/utils/string_constants.dart';
import 'package:flutter_connectivity_app/features/connection/presentation/bloc/connectivity_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeedTestDart tester = SpeedTestDart();
  List<Server> bestServersList = [];
  @override
  void initState() {
    super.initState();
    context.read<ConnectivityBloc>().add(ConnectivityInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.appName),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<Map<String, dynamic>?>(
            stream: FlutterBackgroundService().on('update'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(child: Lottie.asset('assets/loading.json'));
              }

              final data = snapshot.data!;
              String? download = data["download"];
              String? upload = data["upload"];
              String? networkType = data["connectionType"];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(networkType ?? "No internet"),
                  Text(download == null
                      ? "Download 0.0 Mb/s"
                      : "Download $download Mb/s"),
                  Text(upload == null
                      ? "Upload 0.0 Mb/s"
                      : "Upload $upload Mb/s"),
                ],
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          buttonWidget(
              context: context,
              onPressed: () {
                context.read<ConnectivityBloc>().add(ConnectivityStopEvent());
              },
              title: "Stop Services"),
          buttonWidget(
              context: context,
              onPressed: () {
                context.read<ConnectivityBloc>().add(ConnectivityStartEvent());
              },
              title: "Start Services"),
        ],
      ),
    );
  }

  Widget buttonWidget(
      {required BuildContext context,
      required String title,
      required Function() onPressed}) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
