import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapnmaps/resources/utils/network_listener.dart';
import 'package:tapnmaps/ui/screens/splash_screen.dart';

void main() {
  runApp(const TapnApp());
}

class TapnApp extends StatefulWidget {
  const TapnApp({super.key});

  @override
  State<TapnApp> createState() => _TapnAppState();
}

class _TapnAppState extends State<TapnApp> {
  @override
  void initState() {
    super.initState();
    NetworkListener()
        .listenToInternetConnection(); // listen to internet connection
  }

  @override
  void dispose() {
    NetworkListener()
        .cancelNetworkListener(); // cancel internet connection listener
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Tapn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
