import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FirstLoginScreen extends ConsumerWidget {
  const FirstLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final sizes = context.deviceSize;

    AppAlerts.sendFlushbarMessage(ref, context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/images/first_login_screen_1.png",
                    height: sizes.height * 0.3,
                    width: sizes.height * 0.3,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DisplayHeading(
                      fontSize: 30,
                      text: "Flashcard",
                      color: colorScheme.primary,
                    ),
                    const Gap(10),
                    const DisplayText(
                      textAlign: TextAlign.center,
                      text:
                          "Ứng dụng tạo Flash Card \n hỗ trợ học Tiếng Anh 11",
                      color: Colors.black,
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary),
                          onPressed: () {
                            context.push('/signUp');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: DisplayText(text: "Đăng ký"),
                          )),
                    ),
                    const Gap(15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary),
                          onPressed: () {
                            context.push('/logIn');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: DisplayText(text: "Bạn đã có tài khoản ?"),
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
