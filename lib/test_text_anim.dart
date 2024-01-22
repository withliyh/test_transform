import 'package:flutter/material.dart';

class TestTextAnim extends StatefulWidget {
  @override
  _TestTextAnimState createState() => _TestTextAnimState();
}

class _TestTextAnimState extends State<TestTextAnim> {
  Tween<double> anim = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 4000),
      onEnd: () {
        // controller.
      },
      tween: anim,
      builder: (context, value, child) {
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
              value,
              value,
              1.0
            ]).createShader(bounds);
          },
          child: Container(
            child: child,
            color: Colors.transparent,
          ),
        );
      },
      child: Text(
        'Hello World',
        style: TextStyle(fontSize: 40),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Text Anim'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: widget,
              flex: 1,
            ),
            SizedBox(height: 20),
            // Expanded(
            //   child: widget2,
            //   flex: 1,
            // ),
            Expanded(
              child: DefaultTextStyleTransitionExample(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultTextStyleTransitionExample extends StatefulWidget {
  @override
  State<DefaultTextStyleTransitionExample> createState() =>
      _DefaultTextStyleTransitionExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _DefaultTextStyleTransitionExampleState
    extends State<DefaultTextStyleTransitionExample>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late TextStyleTween _styleTween;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _styleTween = TextStyleTween(
      begin: const TextStyle(
          fontSize: 50, color: Colors.blue, fontWeight: FontWeight.w900),
      end: const TextStyle(
          fontSize: 50, color: Colors.blue, fontWeight: FontWeight.w100),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyleTransition(
        style: _styleTween.animate(_curvedAnimation),
        child: const Text('Flutter'),
      ),
    );
  }
}
