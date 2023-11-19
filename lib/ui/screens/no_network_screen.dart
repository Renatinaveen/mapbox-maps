import 'package:flutter/material.dart';

import '../../resources/constants.dart';
import '../../resources/fonts_class.dart';
import '../../resources/theme_class.dart';
import '../../resources/utils/network_listener.dart';

class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({Key? key}) : super(key: key);

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.red),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text('No Internet Connection'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeClass.purple,
            ),
            onPressed: () {
              NetworkListener().listenToInternetConnection().then((value) {
                if (value == true) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text(
              TextConstants.retry,
              style: TextStyle(
                  fontFamily: FontsClass.poppinsFont, color: ThemeClass.black),
            ),
          ),
        ],
      ),
    );
  }
}
