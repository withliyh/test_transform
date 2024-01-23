import 'package:flutter/material.dart';

import 'test_line_animation.dart';

typedef Item = String;

class TestTextAnim extends StatefulWidget {
  @override
  _TestTextAnimState createState() => _TestTextAnimState();
}

class _TestTextAnimState extends State<TestTextAnim> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: Container(
                color: Colors.grey,
                child: SceneScrollWidget(
                  items: [
                    '爱江山更爱美人1',
                    '爱江山更爱美人2',
                    '爱江山更爱美人3',
                    '爱江山更爱美人4',
                    '爱江山更爱美人5',
                    '爱江山更爱美人6',
                  ],
                  listener: null,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TestLineAnimationWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanLineWidget extends StatefulWidget {
  final Widget item;
  final AnimationController? controller;
  ScanLineWidget({
    required this.item,
    this.controller,
  });

  @override
  State<ScanLineWidget> createState() => _ScanLineWidgetState();
}

class _ScanLineWidgetState extends State<ScanLineWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return widget.item;
    }
    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(colors: [
              Colors.blue,
              Colors.blue,
              Colors.red,
              Colors.red,
            ], stops: [
              0.0,
              widget.controller!.value,
              widget.controller!.value,
              1.0
            ]).createShader(bounds);
          },
          child: Container(
            child: child,
            color: Colors.transparent,
          ),
        );
      },
      child: widget.item,
    );
  }
}

class ZoomOutTextWidget extends StatefulWidget {
  final AnimationController controller;
  final Widget child;
  final TextStyleTween textTween;
  ZoomOutTextWidget({
    required this.controller,
    required this.child,
    required this.textTween,
  });
  @override
  State<ZoomOutTextWidget> createState() => _ZoomOutTextState();
}

class _ZoomOutTextState extends State<ZoomOutTextWidget> {
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _curvedAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyleTransition(
      style: widget.textTween.animate(_curvedAnimation),
      child: widget.child,
    );
  }
}

class SceneScrollWidget extends StatefulWidget {
  final List<Item> items;
  final void Function(AnimationStatus)? listener;
  SceneScrollWidget({required this.items, this.listener});
  @override
  State<StatefulWidget> createState() {
    return _SceneScrollState();
  }
}

class _SceneScrollState extends State<SceneScrollWidget>
    with TickerProviderStateMixin {
  late AnimationController scrollAnimation;
  late AnimationController zoomOutAnimation;
  late AnimationController scanAnimation;
  @override
  void initState() {
    super.initState();
    scrollAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    zoomOutAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    scanAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    scanAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scrollAnimation.reset();
        zoomOutAnimation.reset();
        scanAnimation.reset();
        scrollAnimation.forward();
        zoomOutAnimation.forward();
      }
    });

    scrollAnimation.forward();
    zoomOutAnimation.forward();
    scrollAnimation.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        scanAnimation.forward();
      }
    });
  }

  @override
  void dispose() {
    scrollAnimation.dispose();
    zoomOutAnimation.dispose();
    scanAnimation.dispose();
    super.dispose();
  }

  List<Widget> _buildLineWidget() {
    List<Widget> results = [];
    for (int i = 0; i < widget.items.length; i++) {
      Widget child = Text(
        widget.items[i],
        textAlign: TextAlign.center,
      );
      if (i == 0) {
        child = ZoomOutTextWidget(
          controller: zoomOutAnimation,
          child: child,
          textTween: TextStyleTween(
            begin: const TextStyle(
                fontSize: 50, color: Colors.blue, fontWeight: FontWeight.w400),
            end: const TextStyle(
                fontSize: 55, color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        );

        child = ScanLineWidget(
          controller: scanAnimation,
          item: child,
        );
      } else {
        child = DefaultTextStyle(
            style: const TextStyle(
              fontSize: 50,
              color: Colors.blue,
              fontWeight: FontWeight.w400,
            ),
            child: child);
      }
      results.add(child);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: LinearScrollDelegate(
        scrollAnimation: scrollAnimation,
      ),
      children: _buildLineWidget(),
    );
  }
}

class LinearScrollDelegate extends FlowDelegate {
  final Animation<double> scrollAnimation;
  LinearScrollDelegate({required this.scrollAnimation})
      : super(repaint: scrollAnimation);
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final biggest = constraints.biggest;
    return BoxConstraints.tightFor(width: biggest.width, height: 80);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      double lineHeight = context.getChildSize(i)!.height;
      double offset = lineHeight * scrollAnimation.value;
      double y = (lineHeight * i + 1) - offset + lineHeight;
      context.paintChild(i, transform: Matrix4.translationValues(0, y, 0));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }
}
