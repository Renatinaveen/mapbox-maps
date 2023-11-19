import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tapnmaps/models/maps_config_model.dart';
import 'package:tapnmaps/resources/theme_class.dart';
import 'package:tapnmaps/resources/utils/custom_network_image.dart';

class CustomBottomSheet extends StatefulWidget {
  final HappeningPlace happeningPlace;
  const CustomBottomSheet({Key? key, required this.happeningPlace})
      : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.0),
        color: ThemeClass.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Text('${widget.happeningPlace.title}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomNetworkImage(
                imageUrl: widget.happeningPlace.icon,
                borderRadius: BorderRadius.circular(10),
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '${widget.happeningPlace.subTitle}',
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
