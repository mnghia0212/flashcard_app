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
        appBar: AppBar(
          title: const DisplayTitle(
            text: "Màn hình chính",
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<List<DefaultSets>>(
              future: DefaultSetsDatasource().fetchDefaultSets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: DisplayText(
                      text: "Lỗi khi tải các bộ thẻ mặc định",
                      color: Colors.black,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: DisplayText(
                    text: "Lỗi khi tải các bộ thẻ mặc định",
                    color: Colors.black,
                  ));
                } else {
                  final List<DefaultSets> flashcardSets = snapshot.data!;
                  return _listViewCardSets(flashcardSets);
                }
              },
            ),
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
          child: _streamListTile(flashcardSet)),
    );
  }

  ListTile _streamListTile(DefaultSets flashcardSet) {
    return ListTile(
        title: DisplayText(
          text: flashcardSet.title,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        subtitle: const DisplayText(
          text: "",
          color: Colors.black,
          fontSize: 16,
        ),
        leading: Image.asset("assets/images/textbook.png"),
        );
  }
}
