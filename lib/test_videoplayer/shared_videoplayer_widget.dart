import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class SharedVideoPlayerWidget extends StatefulWidget {
  const SharedVideoPlayerWidget({
    Key? key,
    required this.controller,
    this.placeHolderWidget,
    this.controllerBuilder,
  }) : super(key: key);

  final VideoPlayerController controller;
  final Widget? placeHolderWidget;
  final ValueWidgetBuilder<VideoPlayerController>? controllerBuilder;

  @override
  State<SharedVideoPlayerWidget> createState() =>
      _SharedVideoPlayerWidgetState();
}

class _SharedVideoPlayerWidgetState extends State<SharedVideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
    print("videoplayer state initState:$this");
  }

  @override
  void dispose() {
    super.dispose();
    print("videoplayer state dispose:$this");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("videoplayer state deactivate:$this");
  }

  @override
  void activate() {
    super.activate();
    print("videoplayer state activate:$this");
  }

  @override
  Widget build(BuildContext context) {
    print("videoplayer state build:$this");

    // print("videoplayer state ${this}:${widget.controller.value}");

    if (widget.controller.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(
              widget.controller,
              key: UniqueKey(),
            ),
          ),
          if (widget.controllerBuilder != null)
            widget.controllerBuilder!(context, widget.controller)
        ],
      );
    }

    return widget.placeHolderWidget ?? Text('No Initialized');
  }
}
