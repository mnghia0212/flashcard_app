import 'dart:developer';

import 'package:flashcard_app/data/models/flashcard_sets.dart';
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
          ? const EmptyContainer(
              emptyType: EmptyType.set,
            )
          : _listViewCardSets(flashcardSets, ref),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  ListView _listViewCardSets(List<FlashcardSets> flashcardSets, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flashcardSets.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final flashcardSet = flashcardSets[index];
        final cardNumber = ref.read(flashcardSetsProvider.notifier).getCardNumber(flashcardSet.setId);
        return _inkWellListTile(context, flashcardSet, cardNumber);
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  InkWell _inkWellListTile(BuildContext context, FlashcardSets flashcardSet, Stream<int?> cardNumber) {
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
        child: _streamListTile(cardNumber, flashcardSet)
      ),
    );
  }

  ListTile _streamListTile(Stream<int?> cardNumber, FlashcardSets flashcardSet) {
    return ListTile(
      title: StreamBuilder<int?>(
        stream: cardNumber,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); 
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            final count = snapshot.data ?? 0;
            return DisplayText(
              text: "${flashcardSet.title} - $count thẻ",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            );
          }
        },
      ),
      subtitle: DisplayText(
        text: flashcardSet.description,
        color: Colors.black,
        fontSize: 16,
      ),
      leading: Image.asset("lib/assets/images/flashcard_sets.png"),
      trailing: const Icon(Icons.more_vert),
    );
  }

  
}
