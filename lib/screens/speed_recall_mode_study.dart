import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SpeedRecallModeStudy extends ConsumerStatefulWidget {
  final dynamic set;
  const SpeedRecallModeStudy({super.key, required this.set});

  @override
  ConsumerState<SpeedRecallModeStudy> createState() =>
      _SpeedRecallModeStudyState();
}

class _SpeedRecallModeStudyState extends ConsumerState<SpeedRecallModeStudy>
    with TickerProviderStateMixin {
  final AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController progressBarController;
  int answerTime = 3;
  bool isAnswered = false;
  bool isCorrect = false;
  StudyCards? newFlashcard;
  String? randomAnswer;

  @override
  void dispose() {
    progressBarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studyNotifierProvider.notifier).initializeFlashcards(widget.set);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProgressBar();
    });
  }

//   @override
//   void didChangeDependencies() {
//     _initializeProgressBar();
//     super.didChangeDependencies();
//   }

  void _initializeProgressBar() {
    final selectedFlashcard =
        ref.read(studyNotifierProvider).displayedFlashcard;

    progressBarController = AnimationController(
      vsync: this,
      duration: Duration(seconds: answerTime),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !isAnswered) {
          setState(() {
            //progressBarController.stop();
            isCorrect = false;
            isAnswered = true;
            ref
                .read(studyNotifierProvider.notifier)
                .setNextFlashcard(isCorrect, selectedFlashcard!);
            debugPrint("new card: $newFlashcard");
          });
          //progressBarController.stop();
        }
      })
      ..repeat();
  }

  String _getRandomAnswer(List<StudyCards> flashcards) {
    final List<String> answers =
        flashcards.take(flashcards.length).map((fc) => fc.backContent).toList();
    return answers[Random().nextInt(answers.length)];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final studyState = ref.watch(studyNotifierProvider);
    final selectedFlashcard = studyState.displayedFlashcard;
    final flashcards = studyState.remainBox;

    if (randomAnswer == null) {
      setState(() {
        randomAnswer = _getRandomAnswer(flashcards);
      });
    }

    if (selectedFlashcard == null) {
      return const Center(
          child: DisplayText(
        text: "Lỗi khi tải dữ liệu thẻ",
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ));
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Ôn tập trắc nghiệm"),
      body: _buildCardDisplay(selectedFlashcard, context, colors),
    );
  }

  Widget _buildCardDisplay(
      StudyCards selectedFlashcard, BuildContext context, ColorScheme colors) {
    final size = context.deviceSize;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .animate(animation),
          child: child,
        );
      },
      child: SizedBox(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: progressBarController.value,
                backgroundColor: colors.primaryContainer,
                color: colors.primary,
                minHeight: 15,
                borderRadius: BorderRadius.circular(16),
              ),
              const Gap(20),
              _buildCardContainer(selectedFlashcard, colors),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCardContainer(
      StudyCards selectedFlashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(selectedFlashcard.uniqueKey),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
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
    final flashcards = ref.watch(studyNotifierProvider).remainBox;
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
        const Gap(5),
        DisplayText(
            text: randomAnswer ?? "error random answer",
            color: Colors.black,
            fontSize: 19),
        const Gap(50),
        _buildAnswerButtons(selectedFlashcard),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard, flashcards)
      ],
    );
  }

  Row _buildAnswerButtons(StudyCards selectedFlashcard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: isAnswered
              ? null
              : () {
                  setState(() {
                    progressBarController.stop();
                    isAnswered = true;
                    isCorrect = selectedFlashcard.backContent == randomAnswer;
                    newFlashcard = ref
                        .read(studyNotifierProvider.notifier)
                        .setNextFlashcard(isCorrect, selectedFlashcard);
                    debugPrint("yes/no: $isCorrect");
                    debugPrint("new card: $newFlashcard");
                  });
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Padding(
              padding: EdgeInsets.all(20), child: DisplayText(text: "Đúng")),
        ),
        ElevatedButton(
          onPressed: isAnswered
              ? null
              : () {
                  setState(() {
                    progressBarController.stop();
                    isAnswered = true;
                    isCorrect = selectedFlashcard.backContent != randomAnswer;
                    newFlashcard = ref
                        .read(studyNotifierProvider.notifier)
                        .setNextFlashcard(isCorrect, selectedFlashcard);
                    debugPrint("yes/no: $isCorrect");
                    debugPrint("new card: $newFlashcard");
                  });
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Padding(
              padding: EdgeInsets.all(20), child: DisplayText(text: "Sai")),
        ),
      ],
    );
  }

  Row _buildActionButtons(ColorScheme colors, StudyCards selectedFlashcard,
      List<StudyCards> flashcards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildNextCardButton(colors, flashcards)],
    );
  }

  ElevatedButton _buildNextCardButton(
      ColorScheme colors, List<StudyCards> flashcards) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                setState(() {
                  randomAnswer = _getRandomAnswer(flashcards);
                  progressBarController.reset();
                  progressBarController.forward();
                  isAnswered = false;
                });
                ref
                    .read(studyNotifierProvider.notifier)
                    .setDisplayedCardState(newFlashcard!);
              } else {
                debugPrint("SESSION COMPLETED");
              }
            },
      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Icon(Icons.arrow_right_alt, color: Colors.white)),
    );
  }
}