import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DisplayTitle(
          text: "Flashcard screen",
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: GridView.count(
            crossAxisCount: 10,
            mainAxisSpacing: 10,
            children: const [],
          ),
        )
      ),
    );
  }
}