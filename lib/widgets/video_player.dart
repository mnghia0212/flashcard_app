import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              label: DisplayText(
                text: _controller.value.isPlaying ? "Dừng video" : "Phát video"),
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 20)),
            ),
          ],
        ),
        const Gap(10),
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
