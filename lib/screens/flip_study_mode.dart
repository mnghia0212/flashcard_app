import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/widgets/empty_container.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:gap/gap.dart';

class FlipStudyMode extends ConsumerStatefulWidget {
  final String? setId;
  const FlipStudyMode({super.key, required this.setId});

  @override
  ConsumerState<FlipStudyMode> createState() => _FlipStudyModeState();
}

class _FlipStudyModeState extends ConsumerState<FlipStudyMode> {
  int _currentIndex = 0;
  bool _isFrontSide = true;

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardStreamProvider(widget.setId!));
    final setName = ref.read(flashcardSetsProvider).selectedFlashcardSet!.title;

    return Scaffold(
        appBar: _buildAppBar(setName),
        body: flashcardsAsync.when(
          data: (flashcards) => flashcards.isEmpty
              ? const EmptyContainer(emptyType: EmptyType.card)
              : _buildCardView(flashcards),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ));
  }

  Column _buildCardView(List<Flashcards> flashcards) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: flashcards.length,
            controller: PageController(initialPage: _currentIndex),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isFrontSide = true;
              });
            },
            itemBuilder: (context, index) {
              return _buildFlashCard(flashcards[index]);
            },
          ),
        ),
        DisplayText(
          text: "${_currentIndex + 1} / ${flashcards.length}",
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildFlashCard(Flashcards card) {
    final colors = context.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isFrontSide = !_isFrontSide;
        });
      },
      child: Center(
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final flipAnimation =
                  Tween(begin: 1.0, end: 0.0).animate(animation);
              return AnimatedBuilder(
                animation: flipAnimation,
                builder: (context, child) {
                  final rotationAngle = flipAnimation.value;
                  return Transform(
                    transform: Matrix4.rotationY(rotationAngle),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: child,
              );
            },
            child: _isFrontSide
                ? _buildCardContent(
                    card.frontContent, colors.primary, Colors.white)
                : _buildCardContent(
                    card.backContent, const Color(0xffE3E3E3), Colors.black)),
      ),
    );
  }

  Widget _buildCardContent(
      String content, Color containerColor, Color textColor) {
    return Container(
      key: ValueKey(content),
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(3, 5),
              blurRadius: 2)
        ],
      ),
      child: Center(
          child: DisplayText(
        text: content,
        fontSize: 24,
        textAlign: TextAlign.center,
        color: textColor,
      )),
    );
  }

  AppBar _buildAppBar(String setName) {
    return AppBar(title: DisplayTitle(text: "Chế độ lật: $setName"));
  }
}
