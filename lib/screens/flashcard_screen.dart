import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/dialog_create_card.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class FlashcardScreen extends ConsumerWidget {
  final String? setId;
  const FlashcardScreen({super.key, required this.setId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final flashcardsAsync = ref.watch(flashcardStreamProvider(setId!));
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _floatingActionButtonCreateCard(colors, context),
      
      body: flashcardsAsync.when(
          data: (flashcards) {
            if (flashcards.isEmpty) {
              return const Center(child: Text('No flashcards found'));
            }
              return ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return ListTile(
                    title: Text(flashcard.frontContent),
                    subtitle: Text(flashcard.backContent),
                  );
                },
              );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
    );
  }

  Container _floatingActionButtonCreateCard(ColorScheme colors, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: colors.primary, borderRadius: BorderRadius.circular(50)),
      child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const DialogCreateCard();
                });
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          )),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const DisplayTitle(
        text: "Flashcard screen",
        color: Colors.black,
      ),
    );
  }
}
