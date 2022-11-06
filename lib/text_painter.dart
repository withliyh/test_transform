import 'package:flutter/material.dart';

class MyTextPainter extends CustomPainter {
  final TextSpan text;

  MyTextPainter(this.text) : super();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter painter = TextPainter(
      text: text,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: TextHeightBehavior(),
    );
    painter.layout(maxWidth: size.width);
    final w = painter.width;
    final h = painter.height;
    final perferedLines = painter.preferredLineHeight;
    final innminW = painter.minIntrinsicWidth;
    final innmaxW = painter.maxIntrinsicWidth;
    final exec = painter.didExceedMaxLines;
    painter.paint(canvas, const Offset(0, 0));
    print(
        "w:$w, h:$h, perlines:$perferedLines, minW:$innminW, maxW:$innmaxW, exceed:$exec");
  }
}

class MyTextWidget extends StatelessWidget {
  final TextSpan text;

  const MyTextWidget(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyTextPainter(text),
    );
  }
}
