import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DisplayTitle(
              text: "Hãy tạo FlashCard đầu tiên",
              textAlign: TextAlign.center),
          const Gap(10),
          const DisplayText(
            text:
                "Hãy bắt đầu nào! Hãy tạo những bộ thẻ đầu tiên và sau đó tạo FlashCard",
            textAlign: TextAlign.center,
            color: Colors.black,
          ),
          const Gap(15),
          Image.asset(
              "lib/assets/images/empty_flashcard_screen.png")
        ],
      ),
    );
  }
}