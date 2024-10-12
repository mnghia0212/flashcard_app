import 'dart:math';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/displayed_flashcard_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardsAsync = ref.read(flashcardStreamProvider(widget.setId!));
      final currentCard = ref.read(displayedFlashcardProvider);
      flashcardsAsync.whenData((flashcards) {
        if (flashcards.isNotEmpty) {
          ref.read(displayedFlashcardProvider.notifier).state =
              showNextFlashcard(flashcards, currentCard);
        }
      });
    });
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
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
            return const Center(child: CircularProgressIndicator());
          }

          return _cardDisplayed(context, ref, flashcards, colors);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Flashcards? showNextFlashcard(
      List<Flashcards> flashcards, Flashcards? currentCard) {
    final List<Flashcards> incompleteCards =
        flashcards.where((flashcard) => !flashcard.isMaster()).toList();

    if (incompleteCards.isEmpty) {
      return null;
    }

    debugPrint('incomplete: $incompleteCards');
    debugPrint('current: $currentCard');

    // Loại bỏ currentCard khỏi danh sách nếu có
    if (currentCard != null) {
      incompleteCards
          .removeWhere((card) => card.flashcardId == currentCard.flashcardId);
    }

    // Nếu chỉ còn một card duy nhất sau khi loại bỏ, trả lại card đó
    if (incompleteCards.isEmpty) {
      return currentCard;
    }

    // Ưu tiên highPriorityCards, nếu không có, chọn lowPriorityCards hoặc random card
    List<Flashcards> highPriorityCards =
        incompleteCards.where((card) => card.incorrectStreak > 0).toList();

    List<Flashcards> lowPriorityCards =
        incompleteCards.where((card) => card.correctStreak > 0).toList();

    debugPrint('highPriority: $highPriorityCards');
    debugPrint('lowPriority: $lowPriorityCards');

    if (highPriorityCards.isNotEmpty) {
      return highPriorityCards[Random().nextInt(highPriorityCards.length)];
    }

    if (lowPriorityCards.isNotEmpty) {
      return lowPriorityCards[Random().nextInt(lowPriorityCards.length)];
    }

    // Nếu không có ưu tiên, chọn ngẫu nhiên từ incompleteCards
    return incompleteCards[Random().nextInt(incompleteCards.length)];
  }

  void updateFlashcardState(Flashcards flashcard, bool isCorrect) async {
    // Tạo bản sao mới của flashcard với trạng thái được cập nhật
    Flashcards updatedFlashcard = flashcard.copyWith(
      correctStreak: isCorrect ? flashcard.correctStreak + 1 : 0,
      incorrectStreak: isCorrect ? 0 : flashcard.incorrectStreak + 1,
    );

    try {
      // Cập nhật flashcard trong cơ sở dữ liệu
      await ref.read(flashcardsProvider.notifier).updateCard(updatedFlashcard);

      // Cập nhật lại provider với flashcard đã được thay đổi để hiển thị chính xác
      ref.read(displayedFlashcardProvider.notifier).state = updatedFlashcard;

      // Hiển thị thông báo
      if (isCorrect) {
        AppAlerts.showFlushBar(context,
            updatedFlashcard.correctStreak.toString(), AlertType.success);
      } else {
        AppAlerts.showFlushBar(context,
            updatedFlashcard.incorrectStreak.toString(), AlertType.error);
      }
    } catch (e) {
      print("Error updating flashcard: $e");
    }
  }

  bool isSessionComplete(List<Flashcards> flashcards) {
    return flashcards.every((card) => card.isMaster());
  }

  Widget _cardDisplayed(BuildContext context, WidgetRef ref,
      List<Flashcards> flashcards, ColorScheme colors) {
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
          child: _cardContainer(selectedFlashcard, colors, flashcards, ref),
        ),
      ),
    );
  }

  Container _cardContainer(Flashcards selectedFlashcard, ColorScheme colors,
      List<Flashcards> flashcards, WidgetRef ref) {
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
      child: _cardContent(selectedFlashcard, colors, flashcards, ref),
    );
  }

  Column _cardContent(Flashcards selectedFlashcard, ColorScheme colors,
      List<Flashcards> flashcards, WidgetRef ref) {
    return Column(
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
        CommonTextFormField(
          controller: answerController,
          labelText: "",
          icon: const Icon(Icons.question_answer_outlined),
          maxLines: 3,
        ),
        const Spacer(),
        _rowButtonReaction(colors, flashcards, ref)
      ],
    );
  }

  Row _rowButtonReaction(
      ColorScheme colors, List<Flashcards> flashcards, WidgetRef ref) {
    final nowCard = ref.read(displayedFlashcardProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DisplayText(
          text: nowCard!.correctStreak.toString(),
          color: Colors.black,
        ),
        const Gap(10),
        DisplayText(
          text: nowCard.incorrectStreak.toString(),
          color: Colors.black,
        ),
        const Gap(10),
        ElevatedButton(
          onPressed: () {
            final isCorrect = answerController.text.toLowerCase() ==
                nowCard.backContent.toLowerCase();

            // Cập nhật trạng thái của flashcard
            updateFlashcardState(nowCard, isCorrect);

            // Lấy flashcard tiếp theo
            final newFlashcard = showNextFlashcard(flashcards, nowCard);

            if (newFlashcard != null) {
              ref.read(displayedFlashcardProvider.notifier).state =
                  newFlashcard;
            } else {
              print('Session Complete');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: DisplayText(
              text: "Trả lời",
            ),
          ),
        )
      ],
    );
  }

  AppBar _appBar(String setName) {
    return AppBar(title: DisplayTitle(text: "Chế độ viết: $setName"));
  }
}
