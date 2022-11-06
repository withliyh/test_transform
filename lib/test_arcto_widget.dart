import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestArcToWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blueGrey,
        width: 228,
        height: 342,
        child: CustomPaint(
          painter: _Painter(),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final Paint brush = Paint();
  _Painter() {
    brush.color = Colors.red;
    brush.style = PaintingStyle.stroke;
    brush.strokeWidth = 2;
  }
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final width = 228.41668701171876;
    final height = 342.6250305175781;
    final p = Offset(209.2354278564453, 266.339599609375);
    final radius = Offset(114.20834350585938, 171.31251525878907);
    final angle = Offset(45.0, 225.0);

    path.moveTo(p.dx, p.dy);

    // path.arcToPoint(
    //   Offset(2.5379733870067867e-9, 171.3136573422241),
    //   radius: Radius.elliptical(radius.dx, radius.dy),
    //   clockwise: true,
    //   largeArc: true,
    // );
    // final rect = Rect.fromLTWH(p.dx, p.dy, radius.dx, radius.dy);
    final rect = Rect.fromLTWH(0, 0, width, height);
    path.arcTo(rect, degToRad(angle.dx), degToRad(angle.dy), false);
    path.close();

    final bond = path.getBounds();
    print(bond);
    canvas.drawPath(path, brush);
    // canvas.drawRect(Offset.zero & size, brush);
    // canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero), brush);
  }

  // Method to convert degree to radians
  double degToRad(num deg) => deg * (pi / 180.0);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
