import 'package:equatable/equatable.dart';
import '../../models/maps_config_model.dart';

abstract class MapConfigState extends Equatable {
  const MapConfigState();

  @override
  List<Object> get props => [];
}

class AppConfigUninitialized extends MapConfigState {}

class FetchingMapConfig extends MapConfigState {}

class FetchedMapConfig extends MapConfigState {
  final MapConfigModel mapConfig;

  const FetchedMapConfig({required this.mapConfig});
}

class FailedToFetchMapConfig extends MapConfigState {}
