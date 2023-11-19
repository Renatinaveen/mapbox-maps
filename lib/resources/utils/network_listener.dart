import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:get/get.dart';

import '../../ui/screens/no_network_screen.dart';

class NetworkListener {
  late StreamSubscription<InternetStatus> listener;

  Future<bool> listenToInternetConnection() async {
    bool isNetworkAvailable = true;
    listener = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        // if (!kReleaseMode) {
        debugPrint('status: $status');
        // }
        switch (status) {
          case InternetStatus.connected:
            isNetworkAvailable = true;
            break;
          case InternetStatus.disconnected:
            isNetworkAvailable = false;
            listener.cancel();
            Navigator.push(Get.context!,
                MaterialPageRoute(builder: (BuildContext context) {
              return const NoNetworkScreen();
            }));
            break;
        }
      },
    );

    return isNetworkAvailable;
  }

  cancelNetworkListener() {
    listener.cancel();
  }
}
