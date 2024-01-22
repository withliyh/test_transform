import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.url,
    this.placeHolderWidget,
    this.controllerBuilder,
  }) : super(key: key);

  final String url;
  final Widget? placeHolderWidget;
  final ValueWidgetBuilder<VideoPlayerController>? controllerBuilder;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeFuture = _controller!.initialize();
    print("videoplayer state initialize:$this");
    _controller!.addListener(() {
      print(
          "controller ${_controller!} value:${_controller!.value.isInitialized}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
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

    Widget current = FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              if (widget.controllerBuilder != null)
                widget.controllerBuilder!(context, _controller!)
            ],
          );
        }
        return widget.placeHolderWidget ?? Text('No Initialized');
      },
    );
    return current;
  }
}
