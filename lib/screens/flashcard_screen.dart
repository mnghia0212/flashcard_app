import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FlashcardScreen extends ConsumerWidget {
  final String? setId;
  final String? setName;
  const FlashcardScreen(
      {super.key, required this.setId, required this.setName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(setId!));

    return Scaffold(
      appBar: _buildAppBar(context, setId!, setName!),
      floatingActionButton: FloatingActionButtonCreate(
          dialogCreate: DialogCreateCard(setId: setId!)),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Column(
              children: [
                EmptyContainer(emptyType: EmptyType.card),
              ],
            );
          }
          return DisplayListOfFlashcards(flashcards: flashcards, setId: setId!);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String setId, String setName) {
    return AppBar(
        title: DisplayText(
          text: setName,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.push("/commentScreen/$setId");
            },
            icon: Icon(
              Icons.question_answer,
              color: Colors.blue.shade700,
            ),
          )
        ]);
  }
}
