import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/maps_config_model.dart';
import '../resources/events/map_config_events.dart';
import '../resources/map_repo.dart';
import '../resources/states/map_config_states.dart';

class MapConfigBloc extends Bloc<MapConfigEvent, MapConfigState> {
  MapConfigBloc() : super(AppConfigUninitialized()) {
    on<AppStarted>(_onAppStarted);
  }

  _onAppStarted(AppStarted event, Emitter<MapConfigState> emit) async {
    try {
      emit(FetchingMapConfig());
      MapConfigModel mapConfigData = await MapConfigRepository().getMapConfig();
      emit(FetchedMapConfig(
        mapConfig: mapConfigData,
      ));
    } catch (e) {
      emit(FailedToFetchMapConfig());
    }
  }
}
