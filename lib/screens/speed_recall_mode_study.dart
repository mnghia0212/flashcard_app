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
  final String? setId;
  const SpeedRecallModeStudy({super.key, required this.setId});

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
  Flashcards? newFlashcard;
  String? randomAnswer;

  // Card boxes
  List<Flashcards> initialBox = [];
  List<Flashcards> wrongBox = [];
  List<Flashcards> firstRightBox = [];
  List<Flashcards> secondRightBox = [];

  @override
  void dispose() {
    progressBarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeFlashcardsBox();
    _initializeProgressBar();
  }

  void _initializeFlashcardsBox() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardsAsync = ref.read(flashcardStreamProvider(widget.setId!));
      flashcardsAsync.whenData((flashcards) {
        if (flashcards.isNotEmpty && initialBox.isEmpty) {
          setState(() {
            initialBox = List<Flashcards>.from(flashcards);

            ref.read(displayedFlashcardProvider.notifier).state =
                initialBox[Random().nextInt(initialBox.length)];
            randomAnswer = _getRandomAnswer(flashcards);
            progressBarController.forward();
          });
        }
      });
    });
  }

  void _initializeProgressBar() {
    final selectedFlashcard = ref.read(displayedFlashcardProvider);

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
            isCorrect = false;
            isAnswered = true;
            newFlashcard = _getNextFlashcard(isCorrect, selectedFlashcard!);
            debugPrint("new card: $newFlashcard");
          });
          // progressBarController.stop();
        }
      })
      ..repeat();
  }

  Flashcards? _getNextFlashcard(bool isCorrect, Flashcards flashcard) {
    _updateBoxes(isCorrect, flashcard);
    return _selectNextFlashcard(flashcard);
  }

  void _updateBoxes(bool isCorrect, Flashcards flashcard) {
    if (isCorrect) {
      if (initialBox.remove(flashcard)) {
        firstRightBox.add(flashcard);
      } else if (wrongBox.remove(flashcard)) {
        firstRightBox.add(flashcard);
      } else if (firstRightBox.remove(flashcard)) {
        secondRightBox.add(flashcard);
      }
    } else {
      if (initialBox.remove(flashcard)) {
        wrongBox.add(flashcard);
      } else if (firstRightBox.remove(flashcard)) {
        wrongBox.add(flashcard);
      }
    }
    debugPrint(
        "------------------------------------------------------------------------------------------------");
    debugPrint("initial: $initialBox");
    debugPrint("wrong: $wrongBox");
    debugPrint("first: $firstRightBox");
    debugPrint("second: $secondRightBox");
    debugPrint(
        "------------------------------------------------------------------------------------------------");
  }

  Flashcards? _selectNextFlashcard(Flashcards flashcard) {
    if (initialBox.isNotEmpty) {
      return initialBox[Random().nextInt(initialBox.length)];
    }
    if (wrongBox.isNotEmpty) {
      return _getRandomFromBox(wrongBox, flashcard);
    }
    if (firstRightBox.isNotEmpty) {
      return _getRandomFromBox(firstRightBox, flashcard);
    }
    return null;
  }

  Flashcards? _getRandomFromBox(List<Flashcards> box, Flashcards currentCard) {
    if (box.length == 1 && box.first == currentCard) {
      return firstRightBox.isEmpty
          ? box.first
          : firstRightBox[Random().nextInt(firstRightBox.length)];
    }

    Flashcards newCard;
    do {
      newCard = box[Random().nextInt(box.length)];
    } while (newCard == currentCard);

    return newCard;
  }

  String _getRandomAnswer(List<Flashcards> flashcards) {
    final List<String> answers =
        flashcards.take(flashcards.length).map((fc) => fc.backContent).toList();
    return answers[Random().nextInt(answers.length)];
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(widget.setId!));
    final colors = context.colorScheme;
    final setName = ref.read(flashcardSetsProvider).selectedFlashcardSet!.title;
    final selectedFlashcard = ref.watch(displayedFlashcardProvider);

    ref.listen<AsyncValue<List<Flashcards>>>(
        flashcardStreamProvider(widget.setId!), (previous, next) {
      if (next.hasValue && next.value!.isNotEmpty) {
        setState(() {
          initialBox = List<Flashcards>.from(next.value!);
          ref.read(displayedFlashcardProvider.notifier).state =
              initialBox[Random().nextInt(initialBox.length)];

          randomAnswer = _getRandomAnswer(next.value!);
        });
      }
    });

    if (selectedFlashcard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: _buildAppBar(setName),
      body: flashcardsAsync.when(
        data: (flashcards) => flashcards.isEmpty
            ? const EmptyContainer(emptyType: EmptyType.card)
            : _buildCardDisplay(selectedFlashcard, flashcards, context, colors),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCardDisplay(Flashcards selectedFlashcard,
      List<Flashcards> flashcards, BuildContext context, ColorScheme colors) {
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
              _buildCardContainer(flashcards, selectedFlashcard, colors),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCardContainer(List<Flashcards> flashcards,
      Flashcards selectedFlashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(selectedFlashcard.flashcardId),
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
      child: _buildCardContent(flashcards, selectedFlashcard, colors),
    );
  }

  Column _buildCardContent(List<Flashcards> flashcards,
      Flashcards selectedFlashcard, ColorScheme colors) {
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

  Row _buildAnswerButtons(Flashcards selectedFlashcard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: isAnswered
              ? null
              : () {
                  AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
                  setState(() {
                    progressBarController.stop();
                    isAnswered = true;
                    isCorrect = selectedFlashcard.backContent == randomAnswer;
                    newFlashcard =
                        _getNextFlashcard(isCorrect, selectedFlashcard);
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
                  AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
                  setState(() {
                    progressBarController.stop();
                    isAnswered = true;
                    isCorrect = selectedFlashcard.backContent != randomAnswer;
                    newFlashcard =
                        _getNextFlashcard(isCorrect, selectedFlashcard);
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

  Row _buildActionButtons(ColorScheme colors, Flashcards selectedFlashcard,
      List<Flashcards> flashcards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildNextCardButton(colors, flashcards)],
    );
  }

  ElevatedButton _buildNextCardButton(
      ColorScheme colors, List<Flashcards> flashcards) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                ref.read(displayedFlashcardProvider.notifier).state =
                    newFlashcard;
                setState(() {
                  randomAnswer = _getRandomAnswer(flashcards);
                  progressBarController.reset();
                  progressBarController.forward();
                  isAnswered = false;
                });
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

  AppBar _buildAppBar(String setName) {
    return AppBar(title: DisplayTitle(text: setName));
  }
}