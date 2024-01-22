import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TestLineAnimationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestLineState();
  }
}

class _TestLineState extends State<TestLineAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Line> offsets = [];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 2 * 60 * 3600,
      duration: Duration(hours: 2),
      value: 0,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final value = _controller.value;

                  if (offsets.length < 10000) {
                    final r = (value * 3).toInt() % 255;
                    final g = 255 - r;
                    final b = r;
                    offsets.add(
                      Line(Color.fromARGB(0xFF, r, g, b), value,
                          Random().nextDouble()),
                    );
                  }

                  return CustomPaint(
                    painter: TestPainter(offsets, value),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Line {
  Color color;
  double offsetMs;
  double heightOffset;
  Offset? cacheStart;
  Offset? cacheEnd;
  Line(this.color, this.offsetMs, this.heightOffset);
}

class TestPainter extends CustomPainter {
  final List<Line> offsets;
  final double value;
  TestPainter(this.offsets, this.value);
  static const int widthGap = 150;
  @override
  void paint(Canvas canvas, Size size) {
    if (offsets.isEmpty) {
      return;
    }
    int count = size.width ~/ widthGap;
    if (offsets.length > count) {
      // offsets.removeRange(0, offsets.length - count);
    }

    canvas.save();
    int avaible = offsets.length - (size.width ~/ widthGap);
    int startIndex = max(0, min(offsets.length, avaible));

    final baseOffset = offsets.first.offsetMs;

    final minOffsetX = value / 16 * 85;
    final maxOffsetX = minOffsetX + size.width;

    canvas.translate(-minOffsetX, 0);

    for (int i = 0; i < offsets.length; i++) {
      final frameNo = (offsets[i].offsetMs - baseOffset);
      final x = frameNo * widthGap;
      if (x < minOffsetX) {
        continue;
      }
      if (x > maxOffsetX) {
        break;
      }
      final y = offsets[i].heightOffset * size.height;

      offsets[i].cacheStart ??= Offset(x, y);
      offsets[i].cacheEnd ??= Offset(x + widthGap, y);
      canvas.drawLine(
        offsets[i].cacheStart!,
        offsets[i].cacheEnd!,
        Paint()
          ..color = offsets[i].color
          ..strokeWidth = 8,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
