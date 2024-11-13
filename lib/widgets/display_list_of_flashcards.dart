import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class DisplayListOfFlashcards extends StatefulWidget {
  final String setId;
  final List<Flashcards> flashcards;
  const DisplayListOfFlashcards(
      {super.key, required this.setId, required this.flashcards});

  @override
  State<DisplayListOfFlashcards> createState() =>
      _DisplayListOfFlashcardsState();
}

class _DisplayListOfFlashcardsState extends State<DisplayListOfFlashcards> {
  late VideoPlayerController controller;

  @override
  void initState() {
    initVideoUrl();
    super.initState();
  }

  void initVideoUrl() {
    final initVideoCard = widget.flashcards
        .where((flashcard) => flashcard.videoPath != null)
        .toList();

    for (var i in initVideoCard) {
      controller = VideoPlayerController.networkUrl(Uri.parse(i.videoPath!))
        ..initialize().then((_) {
          setState(() {});
        });
      controller.setLooping(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: widget.flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = widget.flashcards[index];
        const titleContainerBackground = Color(0xfff1f1f1);
        const titleContainerTheme = Color(0xff808080);
        final deviceSize = context.deviceSize;
        return Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _cardTitle(titleContainerBackground, index, titleContainerTheme,
                  flashcard, context),
              _cardContent(deviceSize, flashcard, context),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(20);
      },
    );
  }

  Widget _cardContent(
      Size deviceSize, Flashcards flashcard, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 300,
      width: deviceSize.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border:
            Border.all(width: 1, color: Colors.grey, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildExpandedCardSides(flashcard, context),
          if (flashcard.videoPath != null) _buildExpandedVideo(),
        ],
      ),
    );
  }

  Widget _buildExpandedVideo() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: controller.value.isInitialized
            ? VideoPlayer(controller)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildExpandedCardSides(Flashcards flashcard, BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DisplayText(
                text: flashcard.frontContent,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 19,
                maxLines: 3,
              ),
            ),
            if (flashcard.audioPath != null)
              _buildAudioPlayer(flashcard.audioPath!, context),
            if (flashcard.videoPath != null)
              _buildVideoPlayer(flashcard.videoPath!, context),
          ],
        ),
        const Gap(5),
        DisplayText(
          text: flashcard.backContent,
          color: Colors.black,
          maxLines: 3,
        ),
      ],
    ));
  }

  Widget _buildAudioPlayer(String audioUrl, BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    final colors = context.colorScheme;

    return ElevatedButton(
      onPressed: () async {
        await audioPlayer.setUrl(audioUrl);
        audioPlayer.play();
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: colors.primaryContainer,
        padding: const EdgeInsets.all(10),
      ),
      child: const Icon(
        Icons.audio_file,
        color: Colors.black,
      ),
    );
  }

  Widget _buildVideoPlayer(String videoUrl, BuildContext context) {
    final colors = context.colorScheme;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: colors.primaryContainer,
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(
        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.black,
      ),
    );
  }

  Widget _cardTitle(Color titleContainerBackground, int index,
      Color titleContainerTheme, Flashcards flashcard, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: titleContainerBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DisplayText(
            text: (index + 1).toString(),
            fontWeight: FontWeight.bold,
            color: titleContainerTheme,
          ),
          PopupMenuButton(
              onSelected: (value) {
                if (value == 'delete') {
                  showDialogDeleteCard(context, flashcard);
                } else if (value == 'edit') {
                  showDialogUpdateSet(context, flashcard);
                } else {
                  return;
                }
              },
              itemBuilder: (context) => const [
                    PopupMenuItem(
                        value: 'edit',
                        child: DisplayText(text: "Sửa", color: Colors.black)),
                    PopupMenuItem(
                        value: 'delete',
                        child: DisplayText(text: "Xóa", color: Colors.black)),
                    PopupMenuItem(
                        value: 'move',
                        child: DisplayText(
                            text: "Di chuyển", color: Colors.black)),
                  ])
        ],
      ),
    );
  }

  Future<dynamic> showDialogDeleteCard(
      BuildContext context, Flashcards flashcard) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogDeleteFlashcard(flashcard: flashcard);
      },
    );
  }

  Future<dynamic> showDialogUpdateSet(
      BuildContext context, Flashcards flashcard) {
    return showDialog(
        context: context,
        builder: (context) {
          return DialogCreateCard(setId: widget.setId, flashcard: flashcard);
        });
  }
}
