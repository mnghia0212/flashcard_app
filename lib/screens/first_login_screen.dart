import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class FirstLoginScreen extends StatelessWidget {
  const FirstLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 160, 30, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/first_login_screen_1.png",
                  ),
                  DisplayHeading(
                    text: "Flash Card",
                    color: colorScheme.primary,
                  ),
                  const Gap(10),
                  const DisplayText(
                    textAlign: TextAlign.center,
                    text: "Ứng dụng tạo Flash Card hỗ trợ học Tiếng Anh 11",
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const Gap(10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary),
                onPressed: () {
                  context.push('/signUp');
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: DisplayText(text: "Đăng ký"),
                )),
            const Gap(15),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary),
                onPressed: () {
                  context.push('/logIn');
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: DisplayText(text: "Bạn đã có tài khoản ?"),
                )),
          ],
        ),
      ),
    );
  }
}
