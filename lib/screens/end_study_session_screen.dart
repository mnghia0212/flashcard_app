import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/display_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EndStudySessionScreen extends ConsumerWidget {
  final dynamic set;
  final String? studyMode;
  const EndStudySessionScreen(
      {super.key, required this.set, required this.studyMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizes = context.deviceSize;
    final colors = context.colorScheme;
    final userName = ref.watch(userProvider).user!.userName;
    final mode = studyMode == "abcd" ? "Trắc nghiệm" : "Viết";
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/cheer.png",
                scale: 0.9,
              ),
              Positioned(
                  top: 80,
                  child: Image.asset(
                    "assets/images/trophy.png",
                    scale: 0.8,
                  )),
              Positioned(
                bottom: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                                children: [
                              const TextSpan(
                                  text: "Chúc mừng ",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: userName,
                                  style: TextStyle(color: colors.primary))
                            ])),
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: sizes.height * 0.55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const DisplayText(
                    text: "Đã hoàn thành phiên học",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                  RichText(
                    textAlign: TextAlign.center,
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                          children: [
                        const TextSpan(
                            text: "Chế độ học: ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: mode, style: TextStyle(color: colors.primary))
                      ])),
                  const Gap(10),
                  const DisplayText(
                    text: "Hãy chọn làm lại hoặc quay về",
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                  onPressed: () {
                    studyMode == "abcd" 
                      ? context.push('/abcdModeStudy', extra: set)
                      : context.push('/writeModeStudy', extra: set);
                  },
                  label: const DisplayText(
                    text: "Làm lại",
                    color: Colors.black,
                  ),
                  icon: const Icon(Icons.refresh),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(
                      width: 2,
                      color: colors.primary
                    )
                  ),
                ),
                const Gap(20),
                 ElevatedButton(
                  onPressed: () => context.go('/bottomNavigator'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18)
                  ),
                  child: const DisplayText(
                    text: "Quay về",
                  
                  ),
                ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
