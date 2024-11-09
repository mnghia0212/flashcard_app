import 'package:flashcard_app/data/models/flashcard_sets.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
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
    final colors = context.colorScheme;

    return flashcardSetsAsync.when(
      data: (flashcardSets) => flashcardSets.isEmpty
          ? const EmptyContainer(
              emptyType: EmptyType.set,
            )
          : _listViewCardSets(flashcardSets, ref, colors),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  ListView _listViewCardSets(
      List<FlashcardSets> flashcardSets, WidgetRef ref, ColorScheme colors) {
    final unDefaultSets = flashcardSets.where((set) => !set.isDefault).toList();
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: unDefaultSets.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final flashcardSet = unDefaultSets[index];
        final cardNumber = ref
            .read(flashcardSetsProvider.notifier)
            .getCardNumber(flashcardSet.setId);
        return _inkWellListTile(context, flashcardSet, cardNumber, colors, ref);
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  InkWell _inkWellListTile(BuildContext context, FlashcardSets flashcardSet,
      Stream<int?> cardNumber, ColorScheme colors, WidgetRef ref) {
    return InkWell(
      onTap: () => context
          .push('/flashcard/${flashcardSet.setId}/${flashcardSet.title}'),
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
          child:
              _streamListTile(cardNumber, flashcardSet, colors, context, ref)),
    );
  }

  ListTile _streamListTile(Stream<int?> cardNumber, FlashcardSets flashcardSet,
      ColorScheme colors, BuildContext context, WidgetRef ref) {
    return ListTile(
      title: StreamBuilder<int?>(
        stream: cardNumber,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DisplayText(text: "Đang tải", color: Colors.black,);
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
      leading: Image.asset("assets/images/flashcard_sets.png"),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') {
            showDialogDeleteSet(context, flashcardSet);
          } else if (value == 'edit') {
            showDialogUpdateSet(context, flashcardSet);
          } else {
            return;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: DisplayText(text: "Sửa", color: Colors.black),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: DisplayText(text: "Xóa", color: Colors.black),
          ),
          const PopupMenuItem(
            value: 'share',
            child: DisplayText(text: "Chia sẻ", color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showDialogDeleteSet(BuildContext context,
      FlashcardSets flashcardSet) {
    return showDialog(
      context: context,
      builder: (context) {
        return DialogDeleteFlashcardSet(flashcardSet: flashcardSet);
      },
    );
  }

  Future<dynamic> showDialogUpdateSet(
      BuildContext context, FlashcardSets flashcardSet) {
    return showDialog(
        context: context,
        builder: (context) {
          return DialogCreateSet(flashcardSet: flashcardSet);
        });
  }
}
