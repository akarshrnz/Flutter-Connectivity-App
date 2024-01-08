import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkType {
  static Future<String> checkConnectionType() async {
    String connectionType = "";
    try {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        connectionType = "Mobile";
      } else if (connectivityResult == ConnectivityResult.wifi) {
        connectionType = "Wi-Fi";
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        connectionType = "Ethernet";
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        connectionType = "Bluetooth";
      } else if (connectivityResult == ConnectivityResult.none) {
        connectionType = "No internet";
      } else {
        connectionType = "Unknown connection type";
      }
      return connectionType;
    } catch (e) {
      connectionType = "No internet";
      return connectionType;
    }
  }
}
