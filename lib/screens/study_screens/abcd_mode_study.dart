import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AbcdModeStudy extends ConsumerStatefulWidget {
  final dynamic set;
  const AbcdModeStudy({super.key, required this.set});

  @override
  ConsumerState<AbcdModeStudy> createState() => _AbcdModeStudyState();
}

class _AbcdModeStudyState extends ConsumerState<AbcdModeStudy> {
  bool isAnswered = false;
  bool isCorrect = false;
  bool isShuffled = false;
  String? groupValue;
  StudyCards? newFlashcard;
  final AudioPlayer audioPlayer = AudioPlayer();
  String studyMode = "abcd";

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

    return answers;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studyNotifierProvider.notifier).initializeFlashcards(widget.set);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final studyState = ref.watch(studyNotifierProvider);
    final selectedFlashcard = studyState.displayedFlashcard;

    if (selectedFlashcard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: "Ôn tập trắc nghiệm",
         leadingButton: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const DialogCancelStudySession();
                  },
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: _buildCardDisplay(selectedFlashcard, studyState, context, colors),
    );
  }

  Color showAnswerColor(String shuffleAnswer, StudyCards card) {
    if (!isAnswered) {
      return Colors.black;
    } else {
      if (isCorrect) {
        if (shuffleAnswer == card.backContent) {
          return Colors.green;
        } else {
          return Colors.black;
        }
      } else {
        if (shuffleAnswer == card.backContent) {
          return Colors.green;
        } else {
          if (shuffleAnswer == groupValue) {
            return Colors.red;
          } else {
            return Colors.black;
          }
        }
      }
    }
  }

  Widget showAnswerIcon(String shuffleAnswer, StudyCards card) {
    if (!isAnswered) {
      return const SizedBox.shrink();
    } else {
      if (isCorrect) {
        if (shuffleAnswer == card.backContent) {
          return const Icon(
            Icons.check,
            color: Colors.green,
          );
        } else {
          return const SizedBox.shrink();
        }
      } else {
        if (shuffleAnswer == card.backContent) {
          return const Icon(
            Icons.check,
            color: Colors.green,
          );
        } else {
          if (shuffleAnswer == groupValue) {
            return const Icon(Icons.close, color: Colors.red);
          } else {
            return const SizedBox.shrink();
          }
        }
      }
    }
  }

  Widget _buildCardDisplay(StudyCards selectedFlashcard, StudyState studyState,
      BuildContext context, ColorScheme colors) {
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
          child: _buildCardContainer(selectedFlashcard, studyState, colors),
        ),
      ),
    );
  }

  Container _buildCardContainer(
      StudyCards selectedFlashcard, StudyState studyState, ColorScheme colors) {
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
      child: _buildCardContent(selectedFlashcard, studyState, colors),
    );
  }

  Column _buildCardContent(
      StudyCards selectedFlashcard, StudyState studyState, ColorScheme colors) {
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
        _buildOptionRatio(selectedFlashcard, studyState),
        const Spacer(),
        _buildActionButtons(colors, selectedFlashcard, studyState)
      ],
    );
  }

  Widget _buildOptionRatio(
      StudyCards selectedFlashcard, StudyState studyState) {
    List<String>? shuffleAnswers;

    if (studyState.randomAnswer == null) {
      final wrongAnswers =
          _getWrongAnswers(studyState.remainBox, selectedFlashcard);
      shuffleAnswers = _getShuffledAnswers(selectedFlashcard, wrongAnswers);
      //   if (!isShuffled) {
      //     shuffleAnswers.shuffle();
      //   }
    } else {
      shuffleAnswers = ref.watch(studyNotifierProvider).randomAnswer;
    }

    if (shuffleAnswers == null) {
      return const DisplayText(
        text: "Lỗi khi tải câu trả lời",
        color: Colors.black,
      );
    }

    return Column(
      children: List.generate(shuffleAnswers.length, (index) {
        return Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: ListTile(
              title: DisplayText(
                  text: shuffleAnswers![index],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: showAnswerColor(
                      shuffleAnswers[index], selectedFlashcard)),
              leading: Radio<String>(
                value: shuffleAnswers[index],
                groupValue: groupValue,
                onChanged: (value) {
                  if (!isAnswered) {
                    setState(() {
                      groupValue = value;
                      isCorrect = groupValue == selectedFlashcard.backContent;
                      isShuffled = true;
                    });
                  }
                },
              ),
              trailing:
                  showAnswerIcon(shuffleAnswers[index], selectedFlashcard)),
        );
      }),
    );
  }

  Row _buildActionButtons(
      ColorScheme colors, StudyCards selectedFlashcard, StudyState studyState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAnswerButton(selectedFlashcard, colors),
        const Gap(10),
        _buildNextCardButton(colors, selectedFlashcard, studyState)
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
                isAnswered = true;
                newFlashcard = ref
                    .read(studyNotifierProvider.notifier)
                    .setNextFlashcard(isCorrect, selectedFlashcard);
              });
            },
      style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: DisplayText(text: "Trả lời")),
    );
  }

  ElevatedButton _buildNextCardButton(
      ColorScheme colors, StudyCards selectedFlashcard, StudyState studyState) {
    return ElevatedButton(
      onPressed: !isAnswered
          ? null
          : () {
              if (newFlashcard != null) {
                List<String> answerList;
                List<String> wrongAnswers;
                StudyCards? newCard;

                setState(() {
                  ref
                      .read(studyNotifierProvider.notifier)
                      .setDisplayedCardState(newFlashcard!);

                  newCard = ref.watch(studyNotifierProvider).displayedFlashcard;
                  isAnswered = false;
                  wrongAnswers =
                      _getWrongAnswers(studyState.remainBox, newCard!);
                  answerList = _getShuffledAnswers(newCard!, wrongAnswers);
                  answerList.shuffle();

                  log("wrong list :$wrongAnswers");
                  log("random list :$answerList");
                  ref
                      .read(studyNotifierProvider.notifier)
                      .setRandomAnswers(answerList);

                  groupValue = null;
                });
              } else {
                log("set: ${widget.set}");
                log("string $studyMode");
                context.go('/endStudySessionScreen/$studyMode', extra: widget.set);
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
