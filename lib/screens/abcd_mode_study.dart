import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AbcdModeStudy extends ConsumerStatefulWidget {
  final dynamic set;
  const AbcdModeStudy({super.key, required this.set});

  @override
  ConsumerState<AbcdModeStudy> createState() => _AbcdModeStudyState();
}

class _AbcdModeStudyState extends ConsumerState<AbcdModeStudy> {
  bool isAnswered = false;
  bool isCorrect = false;
  String? groupValue;
  List<String>? shuffledAnswers;
  StudyCards? newFlashcard;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<String> _getWrongAnswers(
      List<StudyCards> allStudyCards, StudyCards selectedFlashcard) {
    List<StudyCards> wrongCards =
        allStudyCards.where((fc) => fc != selectedFlashcard).toList();

    List<String> wrongAnswers =
        wrongCards.take(3).map((fc) => fc.backContent).toList();

    return wrongAnswers;
  }

  List<String> _getShuffledAnswers(
      StudyCards selectedFlashcard, List<String> wrongAnswers) {
    List<String> answers = [...wrongAnswers, selectedFlashcard.backContent];

    answers.shuffle();

    return answers;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studyNotifierProvider.notifier).initializeFlashcards(widget.set);
    });
    shuffledAnswers = null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final studyState = ref.watch(studyNotifierProvider);
    final selectedFlashcard = studyState.displayedFlashcard;

    if (selectedFlashcard == null) {
      return const Center(
          child: DisplayText(
        text: "Lỗi khi tải dữ liệu thẻ",
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));
    }

    if (shuffledAnswers == null) {
      final wrongAnswers = _getWrongAnswers(
          studyState.remainBox, studyState.displayedFlashcard!);

      setState(() {
        shuffledAnswers =
            _getShuffledAnswers(studyState.displayedFlashcard!, wrongAnswers);
      });

      log("shuffle: $shuffledAnswers");
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Ôn tập trắc nghiệm"),
      body: _buildCardDisplay(selectedFlashcard, context, colors),
    );
  }

  Widget _buildCardDisplay(
      StudyCards selectedFlashcard, BuildContext context, ColorScheme colors) {
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
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      height: 530,
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
            text: "Chọn đáp án đúng", color: Colors.black, fontSize: 15),
        const Gap(5),
        _buildOptionRatio(selectedFlashcard),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard)
      ],
    );
  }

  Widget _buildOptionRatio(StudyCards selectedFlashcard) {
    return Column(
      children: List.generate(shuffledAnswers!.length, (index) {
        return Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: ListTile(
            title: Text(shuffledAnswers![index]),
            leading: Radio<String>(
              value: shuffledAnswers![index],
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value;
                  //isAnswered = true;
                  isCorrect = groupValue == selectedFlashcard.backContent;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  Row _buildActionButtons(ColorScheme colors, StudyCards selectedFlashcard) {
    final flashcards = ref.watch(studyNotifierProvider).remainBox;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAnswerButton(selectedFlashcard, colors),
        const Gap(10),
        _buildNextCardButton(colors, selectedFlashcard, flashcards)
      ],
    );
  }

  ElevatedButton _buildAnswerButton(
      StudyCards selectedFlashcard, ColorScheme colors) {
    return ElevatedButton(
      onPressed: isAnswered
          ? null
          : () {
              setState(() {
                //AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
                isAnswered = true;
                newFlashcard = ref
                    .read(studyNotifierProvider.notifier)
                    .setNextFlashcard(isCorrect, selectedFlashcard);
                log("isCorrect: $isCorrect");
                log("new cards: $newFlashcard");
              });
            },
      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: DisplayText(text: "Trả lời")),
    );
  }

  ElevatedButton _buildNextCardButton(ColorScheme colors,
      StudyCards selectedFlashcard, List<StudyCards> flashcards) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                setState(() {
                  isAnswered = false;
                  List<String> wrongAnswers =
                      _getWrongAnswers(flashcards, selectedFlashcard);
                  shuffledAnswers =
                      _getShuffledAnswers(selectedFlashcard, wrongAnswers);

                  groupValue = null;
                });
                ref
                    .read(studyNotifierProvider.notifier)
                    .setDisplayedCardState(newFlashcard!);
              } else {
                debugPrint("SESSION COMPLETED");
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
