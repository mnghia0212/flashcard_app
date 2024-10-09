import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DisplayListOfFlashcardSets extends ConsumerWidget {
  const DisplayListOfFlashcardSets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardSetsAsync = ref.watch(flashcardSetsStreamProvider);

    return flashcardSetsAsync.when(
      data: (flashcardSets) => flashcardSets.isEmpty
          ? const EmptyContainer(emptyType: EmptyType.set,)
          : ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: flashcardSets.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final flashcardSet = flashcardSets[index];

                return InkWell(
                  onTap: () => context.push('/flashcard/${flashcardSet.setId}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: DisplayText(
                        text: flashcardSet.title,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      subtitle: DisplayText(
                        text: flashcardSet.description,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      leading: Image.asset("lib/assets/images/flashcard_sets.png"),
                      trailing: const Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Gap(10);
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
