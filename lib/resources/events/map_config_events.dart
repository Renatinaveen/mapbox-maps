import 'package:equatable/equatable.dart';

abstract class MapConfigEvent extends Equatable {
  const MapConfigEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends MapConfigEvent {}

class FetchMapConfig extends MapConfigEvent {}