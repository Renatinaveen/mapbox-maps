import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapnmaps/blocs/map_config_bloc.dart';

import '../../resources/constants.dart';
import '../../resources/events/map_config_events.dart';
import '../../resources/fonts_class.dart';
import '../../resources/theme_class.dart';

class ContentNotFoundScreen extends StatefulWidget {
  final MapConfigBloc mapConfigBloc;
  const ContentNotFoundScreen({Key? key, required this.mapConfigBloc})
      : super(key: key);

  @override
  State<ContentNotFoundScreen> createState() => _ContentNotFoundScreenState();
}

class _ContentNotFoundScreenState extends State<ContentNotFoundScreen> {
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
    return BlocProvider<MapConfigBloc>(
      create: (BuildContext context) {
        return widget.mapConfigBloc;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              children: [
                Icon(Icons.hourglass_empty, size: 100, color: ThemeClass.grey),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('Something went wrong'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeClass.purple,
              ),
              onPressed: () {
                widget.mapConfigBloc.add(FetchMapConfig());
                Navigator.pop(context);
              },
              child: Text(TextConstants.retry,
                  style: TextStyle(
                      fontFamily: FontsClass.poppinsFont,
                      color: ThemeClass.black)),
            ),
          ],
        ),
      ),
    );
  }
}
