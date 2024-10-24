import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum EmptyType { set, card, group }

class EmptyContainer extends StatelessWidget {
  final EmptyType emptyType;
  const EmptyContainer({super.key, required this.emptyType});

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    return SizedBox(
      height: deviceSize.height,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildContent(emptyType),
      ),
    );
  }

  Widget _buildContent(EmptyType type) {
    if (type == EmptyType.set) {
      return _buildEmptySet();
    } else if (type == EmptyType.card) {
      return _buildEmptyCard();
    } else if (type == EmptyType.group) {
      return _buildEmptyGroup();
    } else {
      return const SizedBox.shrink();
    }
  }

  Column _buildEmptySet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DisplayTitle(
            text: "Hãy tạo bộ thẻ đầu tiên", textAlign: TextAlign.center),
        const Gap(10),
        const DisplayText(
          text:
              "Bắt đầu nào! Hãy tạo những bộ thẻ đầu tiên và sau đó tạo FlashCard",
          textAlign: TextAlign.center,
          color: Colors.black,
        ),
        const Gap(15),
        Image.asset("assets/images/empty_flashcard_sets_screen.png")
      ],
    );
  }

  Column _buildEmptyCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DisplayText(
          text: "Bộ thẻ này chưa có thẻ nào! Hãy tạo thẻ để bắt đầu học ",
          textAlign: TextAlign.center,
          color: Colors.black,
        ),
        const Gap(15),
        Image.asset("assets/images/empty_flashcards_screen.png"),
      ],
    );
  }

  Column _buildEmptyGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DisplayTitle(
            text: "Hãy tạo nhóm đầu tiên", textAlign: TextAlign.center),
        const Gap(10),
        const DisplayText(
          text:
              "Hãy bắt đầu nào! Hãy tạo nhóm của bạn để tăng thêm niềm vui học tập",
          textAlign: TextAlign.center,
          color: Colors.black,
        ),
        const Gap(15),
        Image.asset("assets/images/empty_groups_screen.png")
      ],
    );
  }
}
