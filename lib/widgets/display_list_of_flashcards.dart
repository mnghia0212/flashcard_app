import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

class DisplayListOfFlashcards extends StatelessWidget {
  final List<Flashcards> flashcards;
  final String setId;
  const DisplayListOfFlashcards({super.key, required this.flashcards, required this.setId});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        const titleContainerBackground = Color(0xfff1f1f1);
        const titleContainerTheme = Color(0xff808080);
        final deviceSize = context.deviceSize;
        return Container(
          height: 450,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 400,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayText(
            text: flashcard.frontContent,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 19,
          ),
          const Gap(5),
          DisplayText(
            text: flashcard.backContent,
            color: Colors.black,
          ),
          const Spacer(),
          Column(
            children: [
              if (flashcard.audioPath != null)
                _buildAudioPlayer(flashcard.audioPath!, context),
              const Gap(5),
              if (flashcard.videoPath != null)
                _buildVideoPlayer(flashcard.videoPath!)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(String audioUrl, BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    final colors = context.colorScheme;
    return Row(
      children: [
        ElevatedButton.icon(
          label: DisplayText(
              text: audioPlayer.playerState.playing
                  ? "Dừng audio"
                  : "Phát audio"),
          icon: Icon(
            audioPlayer.playerState.playing ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () async {
            await audioPlayer.setUrl(audioUrl);
            audioPlayer.play();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              padding:
                  const EdgeInsets.symmetric(vertical: 13, horizontal: 20)),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    return VideoPlayerWidget(videoUrl: videoUrl);
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
          return DialogCreateCard(setId: setId, flashcard: flashcard);
        });
  }
}
