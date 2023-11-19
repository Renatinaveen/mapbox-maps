import 'dart:convert';

class MapConfigModel {
  final String accessToken;
  final List<double> mainLocation;
  final List<Action> actions;
  final List<HappeningPlace> happeningPlaces;

  MapConfigModel({
    required this.accessToken,
    required this.mainLocation,
    required this.actions,
    required this.happeningPlaces,
  });

  MapConfigModel copyWith({
    String? accessToken,
    List<double>? mainLocation,
    List<Action>? actions,
    List<HappeningPlace>? happeningPlaces,
  }) =>
      MapConfigModel(
        accessToken: accessToken ?? this.accessToken,
        mainLocation: mainLocation ?? this.mainLocation,
        actions: actions ?? this.actions,
        happeningPlaces: happeningPlaces ?? this.happeningPlaces,
      );

  factory MapConfigModel.fromRawJson(String str) =>
      MapConfigModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MapConfigModel.fromJson(Map<String, dynamic> json) => MapConfigModel(
        accessToken: json["access_key"],
        mainLocation: List<double>.from(json["main_location"].map((x) => x)),
        actions:
            List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
        happeningPlaces: List<HappeningPlace>.from(
            json["happening_places"].map((x) => HappeningPlace.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "access_key": accessToken,
        "main_location": List<dynamic>.from(mainLocation.map((x) => x)),
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
        "happening_places":
            List<dynamic>.from(happeningPlaces.map((x) => x.toJson())),
      };
}

class Action {
  final String icon;
  final String title;

  Action({
    required this.icon,
    required this.title,
  });

  Action copyWith({
    String? icon,
    String? title,
  }) =>
      Action(
        icon: icon ?? this.icon,
        title: title ?? this.title,
      );

  factory Action.fromRawJson(String str) => Action.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        icon: json["icon"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
      };
}

class HappeningPlace {
  final String icon;
  final String title;
  final String subTitle;
  final List<List<double>> coords;

  HappeningPlace({
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.coords,
  });

  HappeningPlace copyWith({
    String? icon,
    String? title,
    String? subTitle,
    List<List<double>>? coords,
  }) =>
      HappeningPlace(
        icon: icon ?? this.icon,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        coords: coords ?? this.coords,
      );

  factory HappeningPlace.fromRawJson(String str) =>
      HappeningPlace.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HappeningPlace.fromJson(Map<String, dynamic> json) => HappeningPlace(
        icon: json["icon"],
        title: json["title"],
        subTitle: json["sub_title"],
        coords: List<List<double>>.from(json["coords"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "sub_title": subTitle,
        "coords": List<dynamic>.from(
            coords.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
