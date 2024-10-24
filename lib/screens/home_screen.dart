import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/default_flashcards.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlashcardSets> flashcardSets = defaultFlashcardSets;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const DisplayTitle(text: "Bộ thẻ lớp 11"),
                  const Gap(10),
                  const Gap(15),
                  _listViewCardSets(flashcardSets)
                ],
              ),
            ),
          ),
        ));
  }

  ListView _listViewCardSets(List<FlashcardSets> flashcardSets) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flashcardSets.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final flashcardSet = flashcardSets[index];
        return _containerListTile(context, flashcardSet);
      },
      separatorBuilder: (context, index) {
        return const Gap(10);
      },
    );
  }

  Container _containerListTile(BuildContext context, FlashcardSets flashcardSet) {
    return Container(
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
      child: _streamListTile(flashcardSet)
    );
  }

  ListTile _streamListTile(FlashcardSets flashcardSet) {
    return ListTile(
      title: DisplayText(
        text: flashcardSet.title,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      subtitle: const DisplayText(
        text:"",
        color: Colors.black,
        fontSize: 16,
      ),
      leading: Image.asset("assets/images/flashcard_sets.png"),
      trailing: const Icon(Icons.more_vert)
    );
  }
}
