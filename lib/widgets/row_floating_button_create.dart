import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class RowFloatingButtonCreate extends ConsumerWidget {
  const RowFloatingButtonCreate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardSets = ref.watch(flashcardSetsProvider).flashcardSets;
    final colors = context.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: flashcardSets.isEmpty,
          child: const DisplayText(
            text: "Tạo ở đây",
            color: Colors.black,
          ),
        ),
        const Gap(10),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: colors.primary, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const DialogCreateSet();
                    });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              )),
        )
      ],
    );
  }
}
