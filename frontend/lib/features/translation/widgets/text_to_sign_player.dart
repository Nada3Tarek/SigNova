import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TextToSignPlayer extends StatefulWidget {
  final String videoUrl;

  const TextToSignPlayer({super.key, required this.videoUrl});

  @override
  State<TextToSignPlayer> createState() => _TextToSignPlayerState();
}

class _TextToSignPlayerState extends State<TextToSignPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
