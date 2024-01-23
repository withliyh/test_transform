import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_transform/test_arcto_widget.dart';
import 'package:test_transform/test_line_animation.dart';
import 'package:test_transform/test_resize_image.dart';
import 'package:test_transform/text_painter.dart';

import 'test_counter_widget.dart';
import 'package:flutter/scheduler.dart';
import 'package:test_transform/test_arcto_widget.dart';
import 'package:test_transform/test_nested_scroll.dart';
import 'package:test_transform/test_text_anim.dart';
import 'package:test_transform/test_videoplayer/test_shared_videoplayer_widget.dart';
import 'package:test_transform/test_videoplayer/test_videoplayer_widget.dart';
import 'package:test_transform/text_painter.dart';

import 'safe_url.dart';
import 'test_colorbox.dart';
import 'test_memoryprof.dart';
import 'test_snowflake.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugRepaintRainbowEnabled = false;
  runApp(MaterialApp(
    builder: ((context, child) => TestTextAnim()),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color color = Colors.red;
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        color = Colors.red.withAlpha(timer.tick % 255);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.yellow,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.yellow),
              foregroundColor: MaterialStatePropertyAll(Colors.red),
              textStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        child: Builder(builder: (context) {
          return SizedBox.shrink(
            child: TextButton(
              onPressed: () {
                Theme.of(context).primaryColor;
              },
              child: Text("TextButton"),
            ),
          );
        }),
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = 1.0;
    final w = 352 * scale;
    final h = 52.79999923706055 * scale;
    final fontheight = 44.0 * scale;
    return MaterialApp(
      title: 'Fading Widget Demo',
      home: Center(
        child: SizedBox.fromSize(
          size: Size(w, h),
          child: Container(
            color: Colors.white,
            child: MyTextWidget(TextSpan(
              text: "练一练连选择题",
              style: TextStyle(
                inherit: false,
                fontSize: fontheight,
                fontWeight: FontWeight.bold,
                fontFamily: "幼圆",
                color: Colors.red,
                overflow: TextOverflow.clip,
                decoration: TextDecoration.none,
              ),
              children: [
                TextSpan(
                    text: "44",
                    style: TextStyle(
                      inherit: false,
                      fontSize: fontheight,
                      fontWeight: FontWeight.bold,
                      fontFamily: "幼圆",
                      color: Colors.red,
                      overflow: TextOverflow.clip,
                    ))
              ],
            )),
          ),
        ),
      ),
    );
  }
}

double calcAlignment(double w1, double w2, double px) {
  final halfdelta = (w1 - w2 + 0.1) / 2.0;
  final align = (px - halfdelta) / halfdelta;
  return align;
}

class TestAlignmentWidget extends StatelessWidget {
  final w1 = 50.0;
  final w2 = 50.0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: w1,
        height: w1,
        color: Colors.red,
        child: OverflowBox(
          alignment:
              Alignment(calcAlignment(w1, w2, -50), calcAlignment(w1, w2, 50)),
          maxWidth: max(w1, w2),
          maxHeight: max(w1, w2),
          minWidth: 0,
          minHeight: 0,
          child: Container(
            width: w2,
            height: w2,
            color: Colors.yellow.withAlpha(100),
          ),
        ),
      ),
    );
  }
}

class TestStackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.yellow,
        width: 300,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              child: ColoredBox(color: Colors.red),
              top: 10,
              left: 10,
              right: 10,
              bottom: 10,
            )
          ],
        ),
      ),
    );
  }
}

class TestOverflowBoxWidgt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.yellow,
        foregroundDecoration:
            BoxDecoration(border: Border.all(color: Colors.purple, width: 10)),
        width: 300,
        height: 300,
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxHeight: 500,
          maxWidth: 500,
          child: Container(
            foregroundDecoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 5)),
            width: 500,
            height: 500,
            color: Colors.red.withAlpha(100),
          ),
        ),
      ),
    );
  }
}

class TestPPTCropWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(960, 540),
        child: ColoredBox(
          color: Colors.grey,
          child: Stack(
            children: [
              // Positioned(
              //   child: PresentImageWidget(
              //     child: Image.asset(
              //       "assets/images/image.jpg",
              //       fit: BoxFit.fill,
              //     ),
              //     size: Size(126, 154),
              //     left: 33.05,
              //     top: 39.64,
              //     right: 10.89,
              //     bottom: 11.84,
              //   ),
              //   left: 95,
              //   top: 76,
              // ),
              // Positioned(
              //   child: PresentImageWidget(
              //     child: Image.asset(
              //       "assets/images/image.jpg",
              //       fit: BoxFit.fill,
              //     ),
              //     size: Size(236, 288),
              //     left: -70.10,
              //     top: -56.04,
              //     right: -23.91,
              //     bottom: -10.18,
              //   ),
              //   left: 253,
              //   top: 164,
              // ),
              // Positioned(
              //   child: PresentImageWidget(
              //     child: Image.asset(
              //       "assets/images/image.jpg",
              //       fit: BoxFit.fill,
              //     ),
              //     size: Size(236, 289),
              //     left: -150.03,
              //     top: -111.13,
              //     right: 56.38,
              //     bottom: 43.98,
              //   ),
              //   left: 540,
              //   top: 45,
              // ),
              Positioned(
                child: PresentImageWidget(
                  child: Image.asset(
                    "assets/images/image1.jpg",
                    fit: BoxFit.fill,
                  ),
                  size: Size(414, 283),
                  left: 0.00,
                  top: 0.31,
                  right: -124.49,
                  bottom: -0.31,
                ),
                left: 557,
                top: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PresentImageWidget extends StatelessWidget {
  final Widget child;

  /// 裁剪框包围的大小，也是最终 Shape 的大小
  /// Shape 大小和图片显示的大小不一定相等，只有在4边都不裁剪的情况下才相等
  final Size size;

  /// 以下4个参数表示相对于裁剪框的4个边的举例百分比
  final double left;
  final double top;
  final double right;
  final double bottom;

  /// 基于计算出的 BaseSize  尺寸的裁剪路径，裁剪路径是本地坐标系
  final Path? cropPath;
  PresentImageWidget({
    required this.child,
    required this.size,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    this.cropPath,
  });

  double calcBaseWidth() {
    final width = size.width / (1 - left / 100 - right / 100);
    return width;
  }

  double calcBaseHeight() {
    final height = size.height / (1 - top / 100 - bottom / 100);
    return height;
  }

  //w1 是shape图形宽度
  //w2 是剪裁区宽度
  //px 是剪裁区在shape图形坐标系下的位置
  double calcAlignment(double w1, double w2, double px) {
    assert(w1 != w2, "参数不能相等");
    double halfdelta = (w1 - w2 + 0.1) / 2.0;
    final align = (px - halfdelta) / halfdelta;
    return align;
  }

  Alignment getAlignment() {
    double baseWidth = calcBaseWidth();
    double baseHeight = calcBaseHeight();

    if ((baseWidth - size.width).abs() <= 1E-6) {
      baseWidth += 1;
    }
    if ((baseHeight - size.height).abs() <= 1E-6) {
      baseHeight += 1;
    }
    final x = calcAlignment(size.width, baseWidth, -left / 100 * baseWidth);
    final y = calcAlignment(size.height, baseHeight, -top / 100 * baseHeight);
    return Alignment(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        width: size.width,
        height: size.height,
        child: OverflowBox(
          alignment: getAlignment(),
          maxWidth: calcBaseWidth(),
          maxHeight: calcBaseHeight(),
          minWidth: 0,
          minHeight: 0,
          child: Stack(
            children: [
              Positioned(
                child: ColoredBox(
                  color: Colors.yellow.withAlpha(100),
                ),
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              Positioned(
                child: child,
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
              )
            ],
          ),
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 4),
        ),
        color: Colors.red,
      ),
    );
  }
}

void a() {
  Container(
    color: Colors.blue,
    child: Row(
      children: [
        Image.network(
          '../1.png',
        ),
        Text('B'),
      ],
    ),
  );
}
