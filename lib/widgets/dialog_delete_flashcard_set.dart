import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogDeleteFlashcardSet extends ConsumerStatefulWidget {
  final FlashcardSets flashcardSet;
  const DialogDeleteFlashcardSet({super.key, required this.flashcardSet});

  @override
  ConsumerState<DialogDeleteFlashcardSet> createState() =>
      _DialogDeleteFlashcardSetState();
}

class _DialogDeleteFlashcardSetState
    extends ConsumerState<DialogDeleteFlashcardSet> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingPageProvider);
    final colors = context.colorScheme;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            title: DisplayText(
              text:
                  "Bạn có chắc muốn xóa bộ thẻ (${widget.flashcardSet.title}) chứ ?",
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
                  ref.watch(isLoadingPageProvider.notifier).state = true;

                  await ref
                      .read(flashcardSetsProvider.notifier)
                      .deleteSet(widget.flashcardSet.setId, context)
                      .then((value) {
                    ref.watch(isLoadingPageProvider.notifier).state = false;
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    AppAlerts.showFlushBar(
                      context,
                      "Xóa bộ thẻ thành công",
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
