import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyMemoryProfApp extends StatelessWidget {
  const MyMemoryProfApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Map<int, ui.Image> _imageLeakMap = <int, ui.Image>{};

class _HomeState extends State<Home> {
  Future<void> openGallery(BuildContext context) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => Gallery()));
  }

  ObjectEventListener _eventListener = (objectEvent) {
    if (objectEvent is ObjectCreated) {
      if (objectEvent.object is ui.Image) {
        _imageLeakMap.putIfAbsent(
            objectEvent.object.hashCode, () => objectEvent.object as ui.Image);
      }
    } else if (objectEvent is ObjectDisposed) {
      if (objectEvent.object is ui.Image) {
        _imageLeakMap.remove(objectEvent.object.hashCode);
      }
    }
  };

  @override
  void initState() {
    super.initState();
    MemoryAllocations.instance.addListener(_eventListener);
    Timer.periodic(Duration(seconds: 1), (timer) {
      print("imageLeak count:${_imageLeakMap.length}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    MemoryAllocations.instance.removeListener(_eventListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Start"),
          onPressed: () => openGallery(context),
        ),
      ),
    );
  }
}

class Gallery extends StatefulWidget {
  Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final String imageURL = 'http://127.0.0.1/文件';

  final int maxImageID = 145;

  final int columns = 2;

  final ScrollController controller = ScrollController();

  void animateToOffset(double offset) {
    if (offset > controller.offset) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        controller.animateTo(
          offset,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / columns;

    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: GridView.builder(
        controller: controller,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
        itemBuilder: (context, index) {
          final url = "$imageURL${(index + 1) % maxImageID}.jpg";
          return Image.network(
            url,
            fit: BoxFit.cover,
            height: imageSize,
            width: imageSize,
            frameBuilder: (context, child, frame, _) {
              if (frame == null) return child;
              // animateToOffset(imageSize * (index ~/ columns));
              return child;
            },
          );
        },
      ),
    );
  }
}
