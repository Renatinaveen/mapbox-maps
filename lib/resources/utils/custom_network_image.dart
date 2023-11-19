import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../assets_class.dart';

class CustomNetworkImage extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final Widget? progressWidget;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const CustomNetworkImage(
      {Key? key,
      this.imageUrl,
      this.height,
      this.width,
      this.progressWidget,
      this.fit,
      this.borderRadius})
      : super(key: key);

  @override
  _CustomNetworkImageState createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  bool loading = true;
  bool error = false;
  late File imageFile;

  @override
  void initState() {
    _getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.white70,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(0)),
            height: widget.height,
            width: widget.width,
            child: const Card()),
      );
    } else if (error == true) {
      return Card(
        child: Center(
          child: IconButton(
              icon: const Icon(
                Icons.replay,
                color: Colors.black,
              ),
              onPressed: () {
                _getImage();
              }),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
        child: FadeInImage(
          placeholder: const AssetImage(Assets.logo),
          image: FileImage(imageFile),
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
        ),
      );
    }
  }

  void _getImage() async {
    try {
      File file = await DefaultCacheManager().getSingleFile(widget
          .imageUrl!); // This will download the image from the given url and store in the cache manager directory in the device and return the File object of the image. If the image is already downloaded then it will return the File object of the image.
      setState(() {
        imageFile = file;
        loading = false;
        error = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        loading = false;
        error = true;
      });
    }
  }
}
