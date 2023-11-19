import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:tapnmaps/models/maps_config_model.dart';
import '../../firebase_options.dart';

class MapConfigRepository {
  Future<MapConfigModel> getMapConfig() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();
    var res = await remoteConfig.fetchAndActivate();
    // Using default duration to force fetching from remote server.
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    var remoteConfigData = remoteConfig.getString('maps_config');
    if (!kReleaseMode) {
      debugPrint('map_config: $remoteConfigData');
    }
    var decodedData = jsonDecode(remoteConfigData);
    var appConfigData = MapConfigModel.fromJson(decodedData);
    return appConfigData;
  }
}
