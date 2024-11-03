import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EndStudySessionScreen extends StatelessWidget {
  final String? rightAnswerCount;
  final String? wrongAnswerCount;
  const EndStudySessionScreen(
      {super.key,
      required this.rightAnswerCount,
      required this.wrongAnswerCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: context.deviceSize.width,
            height: context.deviceSize.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(2, 2),
                    blurRadius: 6)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DisplayText(
                  text: "Bạn đã hoàn thành bài kiểm tra",
                  color: context.colorScheme.primary,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                const Gap(20),
                DisplayText(
                  text: "Số câu đúng: $rightAnswerCount",
                  color: Colors.black,
                ),
                const Gap(10),
                DisplayText(
                  text: "Số câu sai: $wrongAnswerCount",
                  color: Colors.black,
                ),
                const Gap(20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_left, color: Colors.black,),
                  onPressed: () => context.go('/bottomNavigator'), 
                  label: const DisplayText(text: "Quay về", color: Colors.black,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
