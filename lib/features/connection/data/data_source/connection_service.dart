import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_connectivity_app/core/utils/data_state.dart';

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_connectivity_app/core/utils/network_type.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

abstract class ConnectionServices {
  Future<DataState<bool>> initConnectionService();
  Future<DataState<bool>> startConnectionService();
  Future<DataState<bool>> stopConnectionService();
}

class ConnectionServicesImpl extends ConnectionServices {
  final FlutterBackgroundService _bgService;

  ConnectionServicesImpl(
    this._bgService,
  );

  @override
  Future<DataState<bool>> initConnectionService() async {
    try {
      await initializeService();
      return const DataSuccess(true);
    } catch (e) {
      return const DataSuccess(false);
    }
  }

  @override
  Future<DataState<bool>> startConnectionService() async {
    try {
      // final service = FlutterBackgroundService();
      // //var isRunning = await _bgService.isRunning();
      _bgService.startService();
      return const DataSuccess(true);
    } catch (e) {
      return const DataSuccess(false);
    }
  }

  @override
  Future<DataState<bool>> stopConnectionService() async {
    try {
      // final service = FlutterBackgroundService();
      // //var isRunning = await _bgService.isRunning();
      _bgService.invoke("stopService");
      return const DataSuccess(true);
    } catch (e) {
      return const DataSuccess(false);
    }
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE',
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Connecting',
        initialNotificationContent: 'Please wait',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        onBackground: onIosBackground,
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  bool isExecuting = false;

  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      String networkType = await NetworkType.checkConnectionType();
      if (networkType == "No internet") {
        showNotification(
            service: service,
            flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
            downloadRate: 0.0,
            uploadRate: 0.0,
            connectionType: networkType);
        service.setForegroundNotificationInfo(
          title: "Connection Check",
          content: '$networkType Downloads 0.0 MB/s / Uploads 0.0 MB/s',
        );
        isExecuting = false;
      } else {
        if (await service.isForegroundService() && isExecuting == false) {
          isExecuting = true;

          SpeedTestDart tester = SpeedTestDart();
          List<Server> bestServersList = [];
          final settings = await tester.getSettings();
          final servers = settings.servers;

          final _bestServersList = await tester.getBestServers(
            servers: servers,
          );
          bestServersList = _bestServersList;
          final downloadRate =
              await tester.testDownloadSpeed(servers: bestServersList);

          final uploadRate =
              await tester.testUploadSpeed(servers: bestServersList);
          isExecuting = false;
          showNotification(
              service: service,
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
              downloadRate: networkType == "No internet" ? 0.0 : downloadRate,
              uploadRate: networkType == "No internet" ? 0.0 : uploadRate,
              connectionType: networkType);

          // flutterLocalNotificationsPlugin.show(
          //   888,
          //   'Connection Check',
          //   'Downloads ${downloadRate.toStringAsFixed(2)} MB/s/Uploads ${uploadRate.toStringAsFixed(2)} MB/s',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'my_foreground',
          //       'MY FOREGROUND SERVICE',
          //       icon: 'ic_bg_service_small',
          //       ongoing: true,
          //     ),
          //   ),
          // );

          service.setForegroundNotificationInfo(
            title: "Connection Check",
            content:
                '$networkType Downloads ${downloadRate.toStringAsFixed(2)} MB/s / Uploads ${uploadRate.toStringAsFixed(2)} MB/s',
          );
          // service.invoke(
          //   'update',
          //   {
          //     "current_date": DateTime.now().toIso8601String(),
          //     "download": downloadRate.toStringAsFixed(2),
          //     "upload": uploadRate.toStringAsFixed(2),
          //   },
          // );
        }
      }
    }
  });
}

void showNotification(
    {required ServiceInstance service,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required double downloadRate,
    required double uploadRate,
    required String connectionType}) {
  flutterLocalNotificationsPlugin.show(
    888,
    'Connection Check',
    '$connectionType Downloads ${downloadRate.toStringAsFixed(2)} MB/s/Uploads ${uploadRate.toStringAsFixed(2)} MB/s',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        ongoing: true,
      ),
    ),
  );

  service.invoke(
    'update',
    {
      "current_date": DateTime.now().toIso8601String(),
      "download": downloadRate.toStringAsFixed(2),
      "upload": uploadRate.toStringAsFixed(2),
      "connectionType": connectionType
    },
  );
}
