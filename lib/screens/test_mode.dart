import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TestMode extends ConsumerStatefulWidget {
  const TestMode({super.key});

  @override
  ConsumerState<TestMode> createState() => _TestModeState();
}

class _TestModeState extends ConsumerState<TestMode> {
  final TextEditingController answerController = TextEditingController();
  bool isAnswered = false;
  bool isCorrect = false;
  DefaultCards? newFlashcard;
  int rightAnswerCount = 0;
  int wrongAnswerCount = 0;

  List<DefaultCards> initialBox = [];

  @override
  void initState() {
    _initializeFlashcardsBoxAsync();
    super.initState();
  }

  Future<void> _initializeFlashcardsBoxAsync() async {
    List<DefaultCards> defaultCards = await getDefaultCards();
    initialBox = getRandomCards(defaultCards);
    ref.read(displayedDefaultFlashcardProvider.notifier).state =
        initialBox[Random().nextInt(initialBox.length)];

    //setState(() {});
  }

  Future<List<DefaultCards>> getDefaultCards() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final QuerySnapshot snapshot =
          await firestore.collection('defaultCards').get();

      final List<DefaultCards> defaultCards = snapshot.docs.map((doc) {
        return DefaultCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultCards;
    } catch (e) {
      debugPrint("Error fetching default sets: $e");
      return [];
    }
  }

  List<DefaultCards> getRandomCards(List<DefaultCards> listCards) {
    Random random = Random();
    List<DefaultCards> randomItems = [];
    List<int> usedIndices = [];

    while (randomItems.length < 3 && randomItems.length < listCards.length) {
      int randomIndex = random.nextInt(listCards.length);

      if (!usedIndices.contains(randomIndex)) {
        randomItems.add(listCards[randomIndex]);
        usedIndices.add(randomIndex);
      }
    }

    return randomItems;
  }

  DefaultCards? _getNextFlashcard(DefaultCards flashcard) {
    _updateBoxes(flashcard);
    return _selectNextFlashcard(flashcard);
  }

  void _updateBoxes(DefaultCards flashcard) {
    initialBox.remove(flashcard);
    debugPrint(
        "------------------------------------------------------------------------------------------------");
    debugPrint("initial: $initialBox");
    debugPrint(
        "------------------------------------------------------------------------------------------------");
  }

  DefaultCards? _selectNextFlashcard(DefaultCards flashcard) {
    if (initialBox.isNotEmpty) {
      return initialBox[Random().nextInt(initialBox.length)];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final selectedFlashcard = ref.watch(displayedDefaultFlashcardProvider);
    return Scaffold(
      body: SafeArea(
        child: _buildCardDisplay(context, colors, selectedFlashcard!),
      ),
    );
  }

  Widget _buildCardDisplay(BuildContext context, ColorScheme colors,
      DefaultCards selectedFlashcard) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
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
      DefaultCards selectedFlashcard, ColorScheme colors) {
    return Container(
      key: ValueKey(selectedFlashcard.flashcardId),
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

  Column _buildCardContent(DefaultCards flashcard, ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayText(
            text: "Câu hỏi / định nghĩa", color: Colors.black, fontSize: 15),
        const Gap(5),
        DisplayText(
            text: flashcard.backContent, color: Colors.black, fontSize: 19),
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

  Row _buildActionButtons(ColorScheme colors, DefaultCards flashcard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isCorrect = answerController.text.toLowerCase().trim() ==
                  flashcard.backContent.toLowerCase().trim();
              isCorrect ? rightAnswerCount++ : wrongAnswerCount++;
              debugPrint("isCorrect: $isCorrect");
              isAnswered = true;
              newFlashcard = _getNextFlashcard(flashcard);
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
                ref.read(displayedDefaultFlashcardProvider.notifier).state =
                    newFlashcard;
                answerController.clear();
                setState(() {
                  isAnswered = false;
                });
              } else {
                final rightNumber = rightAnswerCount.toString();
                final wrongNumber = wrongAnswerCount.toString();
                context
                    .push('/endStudySessionScreen/$rightNumber/$wrongNumber');
                //AppSounds.playEndSessionSound(audioPlayer);
              }
            },
      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Icon(Icons.arrow_right_alt, color: Colors.white)),
    );
  }
}
