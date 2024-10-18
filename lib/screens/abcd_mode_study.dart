import 'dart:math';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AbcdModeStudy extends ConsumerStatefulWidget {
  final String? setId;
  const AbcdModeStudy({super.key, required this.setId});

  @override
  ConsumerState<AbcdModeStudy> createState() => _AbcdModeStudyState();
}

class _AbcdModeStudyState extends ConsumerState<AbcdModeStudy> {
  bool isAnswered = false;
  bool isCorrect = false;
  String? groupValue;
  List<String>? shuffledAnswers;
  Flashcards? newFlashcard;

  // Card boxes
  List<Flashcards> initialBox = [];
  List<Flashcards> wrongBox = [];
  List<Flashcards> firstRightBox = [];
  List<Flashcards> secondRightBox = [];

  @override
  void initState() {
    super.initState();
    _initializeFlashcardsBox();
  }

  void _initializeFlashcardsBox() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardsAsync = ref.read(flashcardStreamProvider(widget.setId!));
      final selectedFlashcard = ref.watch(displayedFlashcardProvider);
      flashcardsAsync.whenData((flashcards) {
        if (flashcards.isNotEmpty && initialBox.isEmpty) {
          setState(() {
            initialBox = List<Flashcards>.from(flashcards);

            ref.read(displayedFlashcardProvider.notifier).state =
                initialBox[Random().nextInt(initialBox.length)];

            List<String> wrongAnswers =
                _getWrongAnswers(flashcards, selectedFlashcard!);
            shuffledAnswers =
                _getShuffledAnswers(selectedFlashcard, wrongAnswers);
            debugPrint(shuffledAnswers.toString());
          });
        }
      });
    });
  }

  Flashcards? _getNextFlashcard(
      bool isCorrect, Flashcards flashcard, List<Flashcards> flashcards) {
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
  }

  Flashcards? _selectNextFlashcard(Flashcards flashcard) {
    if (initialBox.isNotEmpty)
      return initialBox[Random().nextInt(initialBox.length)];
    if (wrongBox.isNotEmpty) return _getRandomFromBox(wrongBox, flashcard);
    if (firstRightBox.isNotEmpty)
      return _getRandomFromBox(firstRightBox, flashcard);
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

  List<String> _getWrongAnswers(
      List<Flashcards> allFlashcards, Flashcards selectedFlashcard) {
    List<Flashcards> wrongCards =
        allFlashcards.where((fc) => fc != selectedFlashcard).toList();

    wrongCards.shuffle();

    List<String> wrongAnswers =
        wrongCards.take(3).map((fc) => fc.backContent).toList();

    return wrongAnswers;
  }

  List<String> _getShuffledAnswers(
      Flashcards selectedFlashcard, List<String> wrongAnswers) {
    List<String> answers = [...wrongAnswers, selectedFlashcard.backContent];

    answers.shuffle();

    return answers;
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(widget.setId!));
    final colors = context.colorScheme;
    final setName = ref.read(flashcardSetsProvider).selectedFlashcardSet!.title;
    final selectedFlashcard = ref.watch(displayedFlashcardProvider);

    if (selectedFlashcard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    ref.listen<AsyncValue<List<Flashcards>>>(
        flashcardStreamProvider(widget.setId!), (previous, next) {
      if (next.hasValue && next.value!.isNotEmpty) {
        setState(() {
          initialBox = List<Flashcards>.from(next.value!);
          ref.read(displayedFlashcardProvider.notifier).state =
              initialBox[Random().nextInt(initialBox.length)];
        });
      }
    });

    return Scaffold(
      appBar: _buildAppBar(setName),
      body: flashcardsAsync.when(
        data: (flashcards) => flashcards.isEmpty
            ? const EmptyContainer(emptyType: EmptyType.card)
            : _buildCardDisplay(flashcards, selectedFlashcard, context, colors),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCardDisplay(List<Flashcards> flashcards,
      Flashcards selectedFlashcard, BuildContext context, ColorScheme colors) {
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

  Container _buildCardContainer(List<Flashcards> flashcards,
      Flashcards selectedFlashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(selectedFlashcard.flashcardId),
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
            text: "Chọn đáp án đúng", color: Colors.black, fontSize: 15),
        const Gap(5),
        _buildOptionRatio(flashcards, selectedFlashcard),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard, flashcards)
      ],
    );
  }

  Widget _buildOptionRatio(
      List<Flashcards> flashcards, Flashcards selectedFlashcard) {
    if (shuffledAnswers == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: List.generate(shuffledAnswers!.length, (index) {
        return Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1, color: Colors.grey)),
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
      ColorScheme colors, Flashcards flashcard, List<Flashcards> flashcards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              newFlashcard =
                  _getNextFlashcard(isCorrect, flashcard, flashcards);
              print("yes/no: $isCorrect");
              print("new card: $newFlashcard");
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

  ElevatedButton _buildNextCardButton(ColorScheme colors, Flashcards flashcard, List<Flashcards> flashcards) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                ref.read(displayedFlashcardProvider.notifier).state =
                    newFlashcard;
                setState(() {
                  isAnswered = false;
                  Flashcards? newFlashcard = _selectNextFlashcard(flashcard);
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
