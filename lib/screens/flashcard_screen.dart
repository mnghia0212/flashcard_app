import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/providers/providers.dart';
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
      appBar: _appBar(setId),
      floatingActionButton:
          _floatingActionButtonCreateCard(colors, context, setId),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const EmptyContainer(emptyType: EmptyType.card);
          }
          return _listviewCard(flashcards);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<String> getSetNameById(String? setId) async {
    try {
      final flashcardSets = await FirebaseFirestore.instance
          .collection('flashcardSets')
          .where('setId', isEqualTo: setId)
          .get();

      if (flashcardSets.docs.isNotEmpty) {
        return flashcardSets.docs.first['title'] as String;
      } else {
        return "Set name not found";
      }
    } catch (e) {
      log("$e");
      return "Error loading set name";
    }
  }

  ListView _listviewCard(List<Flashcards> flashcards) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        const titleContainerBackground = Color(0xfff1f1f1);
        const titleContainerTheme = Color(0xff808080);
        final deviceSize = context.deviceSize;
        return Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _cartTitle(titleContainerBackground, index, titleContainerTheme),
              _cardContent(deviceSize, flashcard),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(20);
      },
    );
  }

  Container _cardContent(Size deviceSize, Flashcards flashcard) {
    return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 190,
                width: deviceSize.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    border: Border.all(
                      width: 1, 
                      color: Colors.grey,
                      style: BorderStyle.solid
                    ),

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayText(
                      text: flashcard.frontContent,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 19,
                    ),
                    const Gap(5),
                    DisplayText(
                      text: flashcard.backContent,
                      color: Colors.black,
                    ),
                  ],
                ),
              );
  }

  Container _cartTitle(Color titleContainerBackground, int index, Color titleContainerTheme) {
    return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                decoration:  BoxDecoration(
                    color: titleContainerBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                    
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DisplayText(
                        text: (index + 1).toString(),
                        fontWeight: FontWeight.bold,
                        color: titleContainerTheme,
                      ),
                    Icon(
                      Icons.more_vert,
                      color: titleContainerTheme,
                    )
                  ],
                ),
              );
  }

  Container _floatingActionButtonCreateCard(
      ColorScheme colors, BuildContext context, String? setId) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: colors.primary, borderRadius: BorderRadius.circular(50)),
      child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogCreateCard(setId: setId);
                });
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          )),
    );
  }

  AppBar _appBar(String? setId) {
    return AppBar(
      title: FutureBuilder(
        future: getSetNameById(setId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DisplayTitle(
              text: "Loading...",
              color: Colors.black,
            );
          }
          if (snapshot.hasError) {
            return const DisplayTitle(
              text: "Error loading set name",
              color: Colors.black,
            );
          } else {
            return DisplayTitle(
              text: snapshot.data ?? "Set name not found",
              color: Colors.black,
            );
          }
        },
      ),
    );
  }
}
