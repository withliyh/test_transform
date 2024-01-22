import 'package:flutter/material.dart';

class StatelessBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: SizedBox.expand(),
    );
  }
}
