import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class DialogDeleteFlashcardSet extends ConsumerWidget {
  final FlashcardSets flashcardSet;
  const DialogDeleteFlashcardSet({super.key, required this.flashcardSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    return AlertDialog(
      title: DisplayText(
        text: "Bạn có chắc muốn xóa bộ thẻ (${flashcardSet.title}) chứ ?",
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
            await ref
                .read(flashcardSetsProvider.notifier)
                .deleteSet(flashcardSet.setId, context)
                .then((value) {
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
