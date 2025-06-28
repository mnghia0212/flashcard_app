import 'package:flashcard_app/config/theme/theme.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppBar(title: "Màn hình chính", isCenterTitle: true,),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GenericFutureBuilder<List<DefaultSets>>(
              future: DefaultSetsDatasource().fetchDefaultSets(), 
              onSuccess: (flashcardSets) => _listViewCardSets(flashcardSets),
            )
          ),
        ));
  }

  Widget _listViewCardSets(List<DefaultSets> flashcardSets) {
    return flashcardSets.isEmpty
        ? const EmptyContainer(emptyType: EmptyType.set)
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
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

  Widget _containerListTile(BuildContext context, DefaultSets flashcardSet) {
    return InkWell(
      onTap: () {
        context.push('/defaultFlashcardsScreen/${flashcardSet.setId}/${flashcardSet.title}');
      },
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.containerDefaultSetsBackground.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _streamListTile(flashcardSet)),
    );
  }

  ListTile _streamListTile(DefaultSets flashcardSet) {
    return ListTile(
        title: DisplayText(
          text: flashcardSet.title,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        subtitle: const DisplayText(
          text: "",
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        leading: Image.asset("assets/images/textbook.png"),
        );
  }
}
