import 'package:flutter/material.dart';
import 'package:test_transform/test_videoplayer/shared_videoplayer_widget.dart';
import 'package:test_transform/test_videoplayer/videoplayer_controller_widget.dart';
import 'package:test_transform/test_videoplayer/videoplayer_widget.dart';
import 'package:video_player/video_player.dart';

String videoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

// Stateful widget to fetch and then display video content.
class SharedVideoApp extends StatefulWidget {
  const SharedVideoApp({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;
  @override
  _SharedVideoAppState createState() => _SharedVideoAppState();
}

class _SharedVideoAppState extends State<SharedVideoApp> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl);
    _controller!.initialize().then((value) {
      setState(() {});
    });
  }

  Future onFullMode2() {
    return showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (BuildContext bc) {
        return MaterialApp(
          home: Material(
            child: Center(
              child: VideoPlayerWidget(
                url: videoUrl,
                placeHolderWidget: Icon(Icons.downloading_outlined),
                controllerBuilder: (context, value) {
                  return VideoControllerWidget(
                    controller: value,
                    onFullScreen: () {
                      Navigator.of(bc).pop();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void onFullMode() {
    Navigator.of(context).push(MaterialPageRoute(builder: (bc) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: Center(
              child: SharedVideoPlayerWidget(
                controller: _controller!,
                placeHolderWidget: Icon(Icons.downloading_outlined),
                controllerBuilder: (bc2, value) {
                  return VideoControllerWidget(
                    controller: value,
                    onFullScreen: () {
                      Navigator.of(bc).pop();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    })).then((value) {
      setState(() {}); //必须调用
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.green,
        width: 500,
        height: 500,
        child: SharedVideoPlayerWidget(
          controller: _controller!,
          controllerBuilder: (context, value) {
            return VideoControllerWidget(
              controller: value,
              onFullScreen: () {
                onFullMode();
              },
            );
          },
        ),
      ),
    );
  }
}
