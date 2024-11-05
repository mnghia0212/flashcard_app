import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DefaultFlashcardsScreen extends StatelessWidget {
  final String? setId;
  final String? setName;
  const DefaultFlashcardsScreen(
      {super.key, required this.setId, required this.setName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "$setName"),
        body: SafeArea(
          child: _buildFutureCards(),
        ));
  }

  Widget _buildFutureCards() {
    return FutureBuilder<List<DefaultCards>>(
      future: fetchDefaultCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: DisplayText(
              text: "Lỗi khi tải các thẻ mặc định",
              color: Colors.black,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: DisplayText(
            text: "Lỗi khi tải các thẻ mặc định",
            color: Colors.black,
          ));
        } else {
          final List<DefaultCards> flashcards = snapshot.data!;
          return _listViewCards(flashcards);
        }
      },
    );
  }

  Widget _listViewCards(List<DefaultCards> flashcards) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        const titleContainerBackground = Color(0xfff1f1f1);
        const titleContainerTheme = Color(0xff808080);
        final deviceSize = context.deviceSize;
        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _cardTitle(titleContainerBackground, index, titleContainerTheme),
              _cardContent(deviceSize, flashcard, context),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Gap(20);
      },
    );
  }

  Widget _cardContent(
      Size deviceSize, DefaultCards flashcard, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 250,
      width: deviceSize.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border:
            Border.all(width: 1, color: Colors.grey, style: BorderStyle.solid),
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
          const Spacer(),
        ],
      ),
    );
  }

  Widget _cardTitle(
      Color titleContainerBackground, int index, Color titleContainerTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
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
          PopupMenuButton(
              itemBuilder: (context) => const [
                    PopupMenuItem(
                        child: DisplayText(
                            text: "Sao chép tới bộ thẻ của bạn",
                            color: Colors.black)),
                  ])
        ],
      ),
    );
  }

  Future<List<DefaultCards>> fetchDefaultCards() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final QuerySnapshot snapshot = await firestore
          .collection('defaultCards')
          .where('setId', isEqualTo: setId)
          .get();

      final List<DefaultCards> defaultCards = snapshot.docs.map((doc) {
        return DefaultCards.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return defaultCards;
    } catch (e) {
      log("Error fetching default sets: $e");
      return [];
    }
  }
}
