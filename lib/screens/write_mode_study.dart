import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class WriteModeStudy extends ConsumerStatefulWidget {
  final dynamic set;
  const WriteModeStudy({super.key, required this.set});

  @override
  ConsumerState<WriteModeStudy> createState() => _WriteModeStudyState();
}

class _WriteModeStudyState extends ConsumerState<WriteModeStudy> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController answerController = TextEditingController();
  bool isAnswered = false;
  bool isCorrect = false;
  StudyCards? newFlashcard;
  late AsyncValue flashcardAsync;

  // Card boxes
  List<StudyCards> initialBox = [];
  List<StudyCards> wrongBox = [];
  List<StudyCards> firstRightBox = [];
  List<StudyCards> secondRightBox = [];

  @override
  void dispose() {
    audioPlayer.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final studyState = ref.watch(studyNotifierProvider);

    if (studyState.initialBox.isEmpty &&
        studyState.wrongBox.isEmpty &&
        studyState.firstRightBox.isEmpty &&
        studyState.secondRightBox.isEmpty) {
      ref.read(studyNotifierProvider.notifier).initializeFlashcards(widget.set);
      return const Center(child: CircularProgressIndicator());
    }

    final selectedFlashcard = studyState.displayedFlashcard;

    if (selectedFlashcard == null) {
      return const Center(
          child: DisplayText(
        text: "Lỗi khi tải dữ liệu thẻ",
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));
    }

    return Scaffold(
        appBar: const CommonAppBar(title: "Ôn tập chế độ viết"),
        body: _buildCardDisplay(context, colors, selectedFlashcard));
  }

  Widget _buildCardDisplay(
      BuildContext context, ColorScheme colors, StudyCards selectedFlashcard) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .animate(animation),
              child: child,
            );
          },
          child: _buildCardContainer(selectedFlashcard, colors),
        ),
      ),
    );
  }

  Container _buildCardContainer(
      StudyCards selectedFlashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(selectedFlashcard.uniqueKey),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 70),
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(2, 2),
              blurRadius: 6)
        ],
      ),
      child: _buildCardContent(selectedFlashcard, colors),
    );
  }

  Column _buildCardContent(StudyCards selectedFlashcard, ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayText(
            text: "Câu hỏi / định nghĩa", color: Colors.black, fontSize: 15),
        const Gap(5),
        DisplayText(
            text: selectedFlashcard.frontContent,
            color: Colors.black,
            fontSize: 19),
        const Gap(20),
        const DisplayText(
            text: "Câu trả lời", color: Colors.black, fontSize: 15),
        const Gap(10),
        _buildAnswerTextField(),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard)
      ],
    );
  }

  TextFormField _buildAnswerTextField() {
    return TextFormField(
      controller: answerController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Nhập câu trả lời của bạn",
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 1, color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(width: 1, color: context.colorScheme.primary)),
      ),
      validator: (value) => value!.isEmpty ? 'Câu trả lời trống' : null,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  Row _buildActionButtons(ColorScheme colors, StudyCards selectedFlashcard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isCorrect = answerController.text.toLowerCase().trim() ==
                  selectedFlashcard.backContent.toLowerCase().trim();
              //AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
              isAnswered = true;

              log("isCorrect: $isCorrect");
              log("isAnswered: $isAnswered");
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: DisplayText(text: "Trả lời")),
        ),
        const Gap(10),
        _buildNextCardButton(colors, selectedFlashcard)
      ],
    );
  }

  ElevatedButton _buildNextCardButton(
      ColorScheme colors, StudyCards selectedFlashcard) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              final studyState = ref.watch(studyNotifierProvider);
              ref
                  .read(studyNotifierProvider.notifier)
                  .setNextFlashcard(isCorrect, selectedFlashcard);


              if (studyState.displayedFlashcard != null) {
                answerController.clear();
                setState(() {
                  isAnswered = false;
                });
              } else {
                log("SESSION COMPLETED");
                AppSounds.playEndSessionSound(audioPlayer);
              }
            },
      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Icon(Icons.arrow_right_alt, color: Colors.white)),
    );
  }
}
