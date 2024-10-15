import 'dart:math';

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
  ConsumerState<ConsumerStatefulWidget> createState() => _WriteModeStudyState();
}

class _WriteModeStudyState extends ConsumerState<WriteModeStudy> {
  final answerController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isAnswered = false;

  //card boxes
  List<Flashcards> initialBox = [];
  List<Flashcards> wrongBox = [];
  List<Flashcards> firstRightBox = [];
  List<Flashcards> secondRightBox = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardsAsync = ref.read(flashcardStreamProvider(widget.setId!));
      flashcardsAsync.whenData((flashcards) {
        if (flashcards.isNotEmpty) {
          initialBox = List<Flashcards>.from(flashcards);
          ref.read(displayedFlashcardProvider.notifier).state =
              initialBox[Random().nextInt(initialBox.length)];
          final card = ref.watch(displayedFlashcardProvider);
          print("selected: $card");
        }
      });
    });
  }

  Flashcards? showNextFlashcard(bool isCorrect, Flashcards flashcard) {
    if (initialBox.isEmpty && wrongBox.isEmpty && firstRightBox.isEmpty) {
      return null;
    }

    if (isCorrect) {
      if (initialBox.contains(flashcard)) {
        initialBox.remove(flashcard);
        firstRightBox.add(flashcard);
      } else if (wrongBox.contains(flashcard)) {
        wrongBox.remove(flashcard);
        firstRightBox.add(flashcard);
      } else if (firstRightBox.contains(flashcard)) {
        firstRightBox.remove(flashcard);
        secondRightBox.add(flashcard);
      }
    } else {
      if (initialBox.contains(flashcard)) {
        initialBox.remove(flashcard);
        wrongBox.add(flashcard);
      } else if (firstRightBox.contains(flashcard)) {
        firstRightBox.remove(flashcard);
        wrongBox.add(flashcard);
      }
    }

    debugPrint('initialBox: ${initialBox.toString()}');
    debugPrint('wrongBox: ${wrongBox.toString()}');
    debugPrint('firstRightBox: ${firstRightBox.toString()}');
    debugPrint('secondRightBox: ${secondRightBox.toString()}');

    if (initialBox.isNotEmpty) {
      return initialBox[Random().nextInt(initialBox.length)];
    }

    /*
    case 1: wrongbox ko null, rightbox ko null, rightbox, wrongbox random = flashcard
    case 2: random wrongbox = flashcard nhưng rightbox []
     */

    /*
    error 1: random lỗi ra số ko có
    error 2: random displayedCard state = card của set học trước
    error 3: build formState 2 lần
     */

    if (wrongBox.isNotEmpty) {
      if (wrongBox.length == 1 && wrongBox.first == flashcard) {
        if (firstRightBox.isEmpty) {
          return wrongBox.first;
        } else {
          return firstRightBox[Random().nextInt(firstRightBox.length)];
        }
      } else {
        while (true) {
          final newfirstWrongBoxCard =
              wrongBox[Random().nextInt(wrongBox.length)];
          if (newfirstWrongBoxCard != flashcard) {
            return newfirstWrongBoxCard;
          }
        }
      }
    }

    if (firstRightBox.isNotEmpty) {
      return firstRightBox[Random().nextInt(firstRightBox.length)];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final flashcardsAsync = ref.watch(flashcardStreamProvider(widget.setId!));
    final selectedFlashcard = ref.watch(displayedFlashcardProvider);
    final setName = ref.read(flashcardSetsProvider).selectedFlashcardSet!.title;

    return Scaffold(
      appBar: _appBar(setName),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const EmptyContainer(emptyType: EmptyType.card);
          }

          if (selectedFlashcard == null) {
            ref.read(displayedFlashcardProvider.notifier).state =
                initialBox[Random().nextInt(initialBox.length)];
          }

          return _cardDisplayed(context, ref, colors);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _cardDisplayed(
      BuildContext context, WidgetRef ref, ColorScheme colors) {
    final selectedFlashcard = ref.watch(displayedFlashcardProvider)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _cardContainer(selectedFlashcard, colors, ref),
        ),
      ),
    );
  }

  Container _cardContainer(
      Flashcards selectedFlashcard, ColorScheme colors, WidgetRef ref) {
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
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: _cardContent(selectedFlashcard, colors, ref),
    );
  }

  Form _cardContent(
      Flashcards selectedFlashcard, ColorScheme colors, WidgetRef ref) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DisplayText(
            text: "Câu hỏi / định nghĩa",
            color: Colors.black,
            fontSize: 15,
          ),
          const Gap(5),
          DisplayText(
            text: selectedFlashcard.frontContent,
            color: Colors.black,
            fontSize: 19,
          ),
          const Gap(20),
          const DisplayText(
            text: "Câu trả lời",
            color: Colors.black,
            fontSize: 15,
          ),
          const Gap(10),
          _textFieldAnswer(selectedFlashcard),
          const Spacer(),
          _rowButtonReaction(colors, ref, selectedFlashcard)
        ],
      ),
    );
  }

  TextFormField _textFieldAnswer(Flashcards selectedFlashcard) {
    return TextFormField(
      maxLines: 3,
      controller: answerController,
      decoration: InputDecoration(
          hintText: "Nhập câu trả lời của bạn",
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.white,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 1,
                color: context.colorScheme.primary,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.red,
              ))),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Câu trả lời trống';
        }
        return null;
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Row _rowButtonReaction(
      ColorScheme colors, WidgetRef ref, Flashcards selectedFlashcard) {
    final bool isCorrect = answerController.text.toLowerCase().trim() ==
        selectedFlashcard.backContent.toLowerCase().trim();
    Flashcards? newFlashcard;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              setState(() {
                isAnswered = true;
                newFlashcard = showNextFlashcard(isCorrect, selectedFlashcard);
                print("new card 1: $newFlashcard");
                print("yes/no: $isCorrect");
                print(
                    "answer: ${answerController.text} ----- back: ${selectedFlashcard.backContent}");
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: DisplayText(
              text: "Trả lời",
            ),
          ),
        ),
        const Gap(10),
        ElevatedButton(
          onPressed: !isAnswered
              ? null
              : () {
                  print("new card 2: $newFlashcard");
                  if (newFlashcard != null) {
                    ref.read(displayedFlashcardProvider.notifier).state =
                        newFlashcard;
                    setState(() {
                      isAnswered = false;
                      answerController.clear();
                    });
                  } else {
                    debugPrint("SESSION COMPLETED");
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
          ),
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              )),
        )
      ],
    );
  }

  AppBar _appBar(String setName) {
    return AppBar(title: DisplayTitle(text: "Chế độ viết: $setName"));
  }
}
