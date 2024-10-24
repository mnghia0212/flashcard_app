import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class WriteModeStudy extends ConsumerStatefulWidget {
  final String? setId;
  const WriteModeStudy({super.key, required this.setId});

  @override
  ConsumerState<WriteModeStudy> createState() => _WriteModeStudyState();
}

class _WriteModeStudyState extends ConsumerState<WriteModeStudy> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController answerController = TextEditingController();
  bool isAnswered = false;
  bool isCorrect = false;
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
      flashcardsAsync.whenData((flashcards) {
        if (flashcards.isNotEmpty && initialBox.isEmpty) {
          setState(() {
            initialBox = List<Flashcards>.from(flashcards);

            ref.read(displayedFlashcardProvider.notifier).state =
                initialBox[Random().nextInt(initialBox.length)];
          });
        }
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    answerController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(widget.setId!));
    final colors = context.colorScheme;
    final setName = ref.read(flashcardSetsProvider).selectedFlashcardSet!.title;

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
            : _buildCardDisplay(context, colors),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCardDisplay(BuildContext context, ColorScheme colors) {
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
          child: _buildCardContainer(selectedFlashcard, colors),
        ),
      ),
    );
  }

  Container _buildCardContainer(Flashcards flashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(flashcard.flashcardId),
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
      child: _buildCardContent(flashcard, colors),
    );
  }

  Column _buildCardContent(Flashcards flashcard, ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayText(
            text: "Câu hỏi / định nghĩa", color: Colors.black, fontSize: 15),
        const Gap(5),
        DisplayText(
            text: flashcard.frontContent, color: Colors.black, fontSize: 19),
        const Gap(20),
        const DisplayText(
            text: "Câu trả lời", color: Colors.black, fontSize: 15),
        const Gap(10),
        _buildAnswerTextField(),
        const Spacer(),
        _buildActionButtons(colors, flashcard)
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

  Row _buildActionButtons(ColorScheme colors, Flashcards flashcard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isCorrect = answerController.text.toLowerCase().trim() ==
                  flashcard.backContent.toLowerCase().trim();
              AppSounds.playSoundRightWrong(isCorrect, audioPlayer);
              isAnswered = true;
              newFlashcard = _getNextFlashcard(isCorrect, flashcard);
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: DisplayText(text: "Trả lời")),
        ),
        const Gap(10),
        _buildNextCardButton(colors)
      ],
    );
  }

  ElevatedButton _buildNextCardButton(ColorScheme colors) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                ref.read(displayedFlashcardProvider.notifier).state =
                    newFlashcard;
                answerController.clear();
                setState(() {
                  isAnswered = false;
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

  AppBar _buildAppBar(String setName) {
    return AppBar(title: DisplayTitle(text: "Chế độ viết: $setName"));
  }
}
