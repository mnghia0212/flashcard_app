import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';

class FlashcardScreen extends ConsumerWidget {
  final String? setId;
  final String? setName;
  const FlashcardScreen({super.key, required this.setId, required this.setName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(setId!));

    return Scaffold(
      appBar: CommonAppBar(title: "$setName"),
      floatingActionButton: FloatingActionButtonCreate(
          dialogCreate: DialogCreateCard(setId: setId)),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Column(
              children: [
                EmptyContainer(emptyType: EmptyType.card),
              ],
            );
          }
          return _listviewCard(flashcards);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _listviewCard(List<Flashcards> flashcards) {
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
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _cardTitle(titleContainerBackground, index, titleContainerTheme),
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
      height: 250,
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

  Widget _cardTitle(
      Color titleContainerBackground, int index, Color titleContainerTheme) {
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
              itemBuilder: (context) => const [
                    PopupMenuItem(
                        child: DisplayText(
                            text: "Di chuyển", color: Colors.black)),
                    PopupMenuItem(
                        child: DisplayText(text: "Sửa", color: Colors.black)),
                    PopupMenuItem(
                        child: DisplayText(text: "Xóa", color: Colors.black)),
                  ])
        ],
      ),
    );
  }
}
