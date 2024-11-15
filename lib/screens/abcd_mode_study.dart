import 'dart:math';

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
  late AsyncValue flashcardAsync;

  // Card boxes
  List<StudyCards> initialBox = [];
  List<StudyCards> wrongBox = [];
  List<StudyCards> firstRightBox = [];
  List<StudyCards> secondRightBox = [];

  StudyCards? _getNextFlashcard(bool isCorrect, StudyCards flashcard) {
    _updateBoxes(isCorrect, flashcard);

    return _selectNextFlashcard(flashcard);
  }

  void _updateBoxes(bool isCorrect, StudyCards flashcard) {
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
        "-----------------------------------------------------------------------");
    debugPrint(
        "initialBox: ${initialBox.map((e) => e.backContent).join(' - ')}");
    debugPrint("wrongBox: ${wrongBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "firstRightBox: ${firstRightBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "secondRightBox: ${secondRightBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "-----------------------------------------------------------------------");
  }

  StudyCards? _selectNextFlashcard(StudyCards flashcard) {
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

  StudyCards? _getRandomFromBox(List<StudyCards> box, StudyCards currentCard) {
    if (box.length == 1 && box.first == currentCard) {
      return firstRightBox.isEmpty
          ? box.first
          : firstRightBox[Random().nextInt(firstRightBox.length)];
    }

    StudyCards newCard;
    do {
      newCard = box[Random().nextInt(box.length)];
    } while (newCard == currentCard);

    return newCard;
  }

  List<String> _getWrongAnswers(
      List<StudyCards> allStudyCards, StudyCards selectedFlashcard) {
    List<StudyCards> wrongCards =
        allStudyCards.where((fc) => fc != selectedFlashcard).toList();

    wrongCards.shuffle();

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
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final selectedFlashcard = ref.watch(displayedFlashcardProvider);

    final setId = widget.set is DefaultSets
        ? (widget.set as DefaultSets).setId
        : (widget.set as FlashcardSets).setId;

    final flashcardAsync = widget.set is DefaultSets
        ? ref.watch(defaultCardsFutureProvider(setId))
        : ref.watch(flashcardStreamProvider(setId));

    flashcardAsync.whenData((flashcards) {
      if (initialBox.isEmpty &&
          firstRightBox.isEmpty &&
          secondRightBox.isEmpty &&
          wrongBox.isEmpty) {
        setState(() {
          initialBox = List<StudyCards>.from(flashcards);

          if (initialBox.isNotEmpty) {
            ref.read(displayedFlashcardProvider.notifier).state =
                initialBox[Random().nextInt(initialBox.length)];
          }
        });
      }
    });

    if (selectedFlashcard != null && shuffledAnswers == null) {
      setState(() {
        final wrongAnswers = _getWrongAnswers(initialBox, selectedFlashcard);
        shuffledAnswers = _getShuffledAnswers(selectedFlashcard, wrongAnswers);
      });
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Ôn tập trắc nghiệm"),
      body: flashcardAsync.when(
        data: (flashcards) => flashcards.isEmpty
            ? const EmptyContainer(emptyType: EmptyType.card)
            : _buildCardDisplay(flashcards, context, colors),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCardDisplay(
      List<StudyCards> flashcards, BuildContext context, ColorScheme colors) {
    final selectedFlashcard = ref.watch(displayedFlashcardProvider);
    if (selectedFlashcard == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
          child: _buildCardContainer(flashcards, selectedFlashcard, colors),
        ),
      ),
    );
  }

  Container _buildCardContainer(List<StudyCards> flashcards,
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
      child: _buildCardContent(flashcards, selectedFlashcard, colors),
    );
  }

  Column _buildCardContent(List<StudyCards> flashcards,
      StudyCards selectedFlashcard, ColorScheme colors) {
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
        _buildOptionRatio(flashcards, selectedFlashcard),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard, flashcards)
      ],
    );
  }

  Widget _buildOptionRatio(
      List<StudyCards> flashcards, StudyCards selectedFlashcard) {
    if (shuffledAnswers == null || shuffledAnswers!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  isAnswered = true;
                  isCorrect = groupValue == selectedFlashcard.backContent;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  Row _buildActionButtons(
      ColorScheme colors, StudyCards flashcard, List<StudyCards> flashcards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
              newFlashcard =
                  _getNextFlashcard(isCorrect, flashcard);
              debugPrint("yes/no: $isCorrect");
              debugPrint("new card: $newFlashcard");
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: DisplayText(text: "Trả lời")),
        ),
        const Gap(10),
        _buildNextCardButton(colors, flashcard, flashcards)
      ],
    );
  }

  ElevatedButton _buildNextCardButton(
      ColorScheme colors, StudyCards flashcard, List<StudyCards> flashcards) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                ref.read(displayedFlashcardProvider.notifier).state =
                    newFlashcard;
                setState(() {
                  isAnswered = false;
                  StudyCards? newFlashcard = _selectNextFlashcard(flashcard);
                  if (newFlashcard != null) {
                    List<String> wrongAnswers =
                        _getWrongAnswers(flashcards, newFlashcard);
                    shuffledAnswers =
                        _getShuffledAnswers(newFlashcard, wrongAnswers);
                  }

                  groupValue = null;
                });
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
