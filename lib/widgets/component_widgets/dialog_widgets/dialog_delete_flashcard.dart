import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogDeleteFlashcard extends ConsumerWidget {
  final Flashcards flashcard;
  const DialogDeleteFlashcard({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingPageProvider);
    final colors = context.colorScheme;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            title: DisplayText(
              text: "Bạn có chắc muốn xóa thẻ chứ ?",
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const DisplayText(
                  text: "Hủy",
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () async {
                  ref.read(isLoadingPageProvider.notifier).state = true;
                  await ref
                      .read(flashcardsProvider.notifier)
                      .deleteCard(flashcard.flashcardId)
                      .then((value) {
                    ref.read(isLoadingPageProvider.notifier).state = false;
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    AppAlerts.showFlushBar(
                      context,
                      "Đã xóa thẻ",
                      AlertType.success,
                    );
                  });
                },
                child: const DisplayText(
                  text: "Xóa",
                  color: Colors.black,
                ),
              ),
            ],
          );
  }
}
