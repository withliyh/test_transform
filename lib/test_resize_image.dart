import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class TestResizeImage extends StatefulWidget {
  const TestResizeImage({Key? key}) : super(key: key);

  @override
  State<TestResizeImage> createState() => _TestResizeImageState();
}

class _TestResizeImageState extends State<TestResizeImage> {
  double scale = 10.0;
  Offset translate = Offset.zero;
  late ImageProvider imageProvider;
  @override
  void initState() {
    super.initState();
    imageProvider = FileImage(
      File(
          "D:\\Downloads\\世界名画赏析-1-15\\slide7_1_PDnZytvD-CSpl-3N7f-Sq17-HAboRMIcDbYP.jpg"),
    );
    imageProvider = ResizeImage(imageProvider, width: 60703, height: 1594);

    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final imageListener = ImageStreamListener((image, synchronousCall) {
      print("${image.toString()}");
    });
    imageStream.addListener(imageListener);
  }

  void onPointerScroll(PointerScrollEvent event) {
    final STEP = 0.1;
    if (event.scrollDelta.dy > 0) {
      if (scale + STEP < 300) {
        scale += STEP;
      }
    } else {
      if (scale - STEP > 0.01) {
        scale -= STEP;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxWidth: 10000000000000,
      maxHeight: 10000000000000,
      minWidth: 0,
      minHeight: 0,
      child: Container(
        color: Colors.green,
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 4,
          ),
        ),
        child: Image(
          image: imageProvider,
          fit: BoxFit.none,
          filterQuality: FilterQuality.medium,
          width: 60703,
          height: 1594,
          isAntiAlias: true,
        ),
      ),
    );
  }
}
