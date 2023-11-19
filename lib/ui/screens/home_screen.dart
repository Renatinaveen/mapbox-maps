import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tapnmaps/blocs/map_config_bloc.dart';
import 'package:tapnmaps/models/maps_config_model.dart';
import 'package:tapnmaps/resources/events/map_config_events.dart';
import 'package:tapnmaps/resources/states/map_config_states.dart';
import 'package:http/http.dart' as http;
import 'package:tapnmaps/resources/theme_class.dart';
import 'package:tapnmaps/ui/components/bottom_sheet.dart';
import 'content_not_found_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  MapboxMap? mapboxMap; // Mapbox map object
  PointAnnotation? pointAnnotation; // Point annotation object
  PointAnnotationManager? pointAnnotationManager; // Point annotation manager
  CircleAnnotationManager? circleAnnotationManager; // Circle annotation manager

  MapConfigBloc? _mapConfigBloc; // Map config bloc
  MapConfigModel? _mapConfig; // Map config model
  int selectedActionsIndex = 0; // Set the selected index

  @override
  void initState() {
    super.initState();
    _mapConfigBloc = MapConfigBloc(); // Initialize map config bloc
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap; // Initialize mapbox map object
    drawCircularAnnotation(); // Draw circular annotation indicating the main location
  }

  drawCircularAnnotation() {
    // Draw circular annotation indicating the main location
    mapboxMap!.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
      createOneAnnotation();

      var options = <CircleAnnotationOptions>[];
      options.add(CircleAnnotationOptions(
          geometry: Point(
              coordinates: Position(
            _mapConfig!.mainLocation[0],
            _mapConfig!.mainLocation[1],
          )).toJson(),
          circleColor: Colors.blue.value,
          circleRadius: 8.0));
      circleAnnotationManager?.createMulti(options);
    });
  }

  void createOneAnnotation() {
    // Create one annotation
    circleAnnotationManager?.create(CircleAnnotationOptions(
      geometry: Point(
          coordinates: Position(
        _mapConfig!.mainLocation[0],
        _mapConfig!.mainLocation[1],
      )).toJson(),
      circleColor: Colors.white.value,
      circleRadius: 12.0,
    ));
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    // On style loaded callback
    drawCustomMarkers(); // Draw custom markers
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            _mapConfigBloc!..add(AppStarted()), // Add app started event
        child: BlocListener<MapConfigBloc, MapConfigState>(
            listener: (context, state) {
          if (state is FetchedMapConfig) {
            if (kDebugMode) {
              print(
                'MapConfigBloc: ${state.mapConfig}',
              );
            }
            _mapConfig = state.mapConfig;
          }
          if (state is FailedToFetchMapConfig) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContentNotFoundScreen(
                        mapConfigBloc: _mapConfigBloc!,
                      )),
            );
          }
        }, child: BlocBuilder<MapConfigBloc, MapConfigState>(
          builder: (BuildContext context, MapConfigState state) {
            if (state is FetchedMapConfig) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      heroTag: 'myLocation',
                      onPressed: () {
                        mapboxMap?.flyTo(
                            CameraOptions(
                                center: Point(
                                        coordinates: Position(
                                            _mapConfig!.mainLocation[0],
                                            _mapConfig!.mainLocation[1]))
                                    .toJson(),
                                zoom: 12.0),
                            MapAnimationOptions(
                                duration: 2000, startDelay: 500));
                      },
                      child: const Icon(Icons.my_location)),
                  body: Stack(children: [
                    MapWidget(
                      key: const ValueKey("mapWidget"),
                      resourceOptions:
                          ResourceOptions(accessToken: _mapConfig!.accessToken),
                      cameraOptions: CameraOptions(
                          center: Point(
                                  coordinates: Position(
                                      _mapConfig!.mainLocation[0],
                                      _mapConfig!.mainLocation[1]))
                              .toJson(),
                          zoom: 12.0),
                      styleUri: MapboxStyles.DARK,
                      textureView: true,
                      onMapCreated: _onMapCreated,
                      onStyleLoadedListener: _onStyleLoadedCallback,
                      onTapListener: (ScreenCoordinate coords) {},
                    ),
                    renderCustomActionsBar(context),
                  ]));
            }
            return const Center(child: CircularProgressIndicator());
          },
        )));
  }

  renderCustomActionsBar(BuildContext context) {
    // Render custom actions bar at top of the screen
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
            controller: PageController(
                viewportFraction: 0.4,
                initialPage: selectedActionsIndex,
                keepPage: true),
            itemCount: _mapConfig!.actions.length,
            onPageChanged: (index) {
              setState(() {
                selectedActionsIndex = index;
                mapboxMap?.flyTo(
                    CameraOptions(
                        center: Point(
                                coordinates: Position(
                                    _mapConfig!.happeningPlaces[index].coords[0]
                                        [0],
                                    _mapConfig!.happeningPlaces[index].coords[0]
                                        [1]))
                            .toJson(),
                        zoom: 15.0),
                    MapAnimationOptions(duration: 2000, startDelay: 500));
              });
            },
            itemBuilder: (context, index) {
              return Chip(
                avatar: Image.network(_mapConfig!.actions[index].icon,
                    height: 20, width: 20, fit: BoxFit.cover),
                label: Text(
                  _mapConfig!.actions[index].title,
                  style: const TextStyle(color: ThemeClass.purple),
                ),
                backgroundColor: selectedActionsIndex == index
                    ? ThemeClass.yellow
                    : ThemeClass.lightPurple,
              );
            }));
  }

  void drawCustomMarkers() async {
    for (var mapData in _mapConfig!.happeningPlaces) {
      // Draw custom markers from map config data
      // Replace the URL with your actual image URL
      final String imageUrl = mapData.icon;

      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List list = response.bodyBytes;
        mapboxMap?.annotations
            .createPointAnnotationManager()
            .then((value) async {
          pointAnnotationManager = value;
          var options = <PointAnnotationOptions>[];
          for (var i = 0; i < 5; i++) {
            options.add(PointAnnotationOptions(
                geometry: Point(
                    coordinates: Position(
                  mapData.coords[0][0],
                  mapData.coords[1][1],
                )).toJson(),
                image: list,
                textField: mapData.title,
                textColor: 0xffffffff,
                textSize: 12.0,
                textJustify: TextJustify.CENTER,
                iconSize: 0.3));
          }
          pointAnnotationManager?.createMulti(options);

          var placesOptions = <PointAnnotationOptions>[];
          placesOptions.add(PointAnnotationOptions(
              geometry: Point(
                  coordinates: Position(
                mapData.coords[0][0],
                mapData.coords[1][1],
              )).toJson(),
              image: list,
              textField: mapData.title,
              textColor: 0xffffffff,
              textSize: 12.0,
              textJustify: TextJustify.CENTER,
              iconSize: 0.3));
          pointAnnotationManager?.createMulti(placesOptions);
          pointAnnotationManager
              ?.addOnPointAnnotationClickListener(AnnotationClickListener(
            mapConfig: _mapConfig,
          ));
        });
      } else {
        // Handle error loading image
        if (kDebugMode) {
          print('Failed to load image. Status code: ${response.statusCode}');
        }
      }
    }
  } //drawCustomMarkers with image and text
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  MapConfigModel? mapConfig;
  AnnotationClickListener({required this.mapConfig});
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    if (kDebugMode) {
      print('Annotation Clicked: ${annotation.iconImage}');
    }
    for (var happeningPlace in mapConfig!.happeningPlaces) {
      if (annotation.textField == happeningPlace.title) {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.0),
              topRight: Radius.circular(26.0),
            ),
          ),
          isScrollControlled: false,
          context: Get.context!,
          builder: (BuildContext bc) {
            return CustomBottomSheet(
                happeningPlace:
                    happeningPlace); // Custom bottom sheet with data from map config
          },
        );
      }
    }
  }
}
