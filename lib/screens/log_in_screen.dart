import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/auth/auth.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final auth = AuthService();
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    const isRemember = false;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(30),

            //Heading login page
            const DisplayHeading(text: "Chào mừng bạn trở lại !"),
            const Gap(30),

            // Email field
            CommonTextFormField(
              labelText: "Địa chỉ Email",
              icon: const Icon(Icons.email_outlined),
              controller: emailController,
              type: TextInputType.emailAddress,
            ),
            const Gap(20),

            // Password field
            CommonTextFormField(
              labelText: "Mật khẩu",
              icon: const Icon(Icons.lock_outlined),
              controller: passwordController,
              isPassword: true,
            ),
            const Gap(5),

            //check box remember login info
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isRemember,
                  onChanged: (value) {
                    value = !isRemember;
                  },
                ),
                const DisplayText(
                  text: "Nhớ thông tin đăng nhập",
                  color: Colors.black,
                )
              ],
            ),

            const Gap(10),

            RichText(
                text: TextSpan(style: const TextStyle(fontSize: 17), children: [
              const TextSpan(
                  text: "Quên mật khẩu ? ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "Bấm vào đây",
                  style: TextStyle(color: colorScheme.primary))
            ])),

            const Gap(30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                login();
              },
              child: const DisplayText(
                text: "Đăng nhập",
              ),
            ),

            const Gap(310),

            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: const TextStyle(fontSize: 17),
                children: [
                  const TextSpan(
                    text: 'Bạn chưa có Tài khoản ? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: 'Đăng ký',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push("/signUp");
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      // Bước 1: Đăng nhập người dùng qua Supabase
      final response = await supabase.auth.signInWithPassword(
          email: emailController.text, password: passwordController.text);

      if (response.user == null) {
        log("login failed.");
        return;
      }

      // Bước 2: Lấy userId từ phiên đăng nhập của Supabase
      final userId = response.user!.id;
      final email = response.user!.email;

      log("userId auth: $userId");

      // Bước 3: Truy vấn Firestore để lấy thông tin người dùng
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        log("User data from Firestore: $userData");

        if (userData != null) {
          final userName = userData['userName'] as String?;
          final email = userData['email'] as String?;

          if (userName != null && email != null) {
            log("username db: $userName");
            log("email db: $email");

            ref.read(userProvider.notifier).updateUser(Users(
                  userId: userId,
                  userName: userName,
                  email: email,
                  password: "",
                ));
            ref.read(userIdProvider.notifier).state = userId;
            log("login success");

            // Điều hướng sang màn hình chính
            context.push('/bottomNavigator');
          } else {
            log("Missing fields in Firestore data");
          }
        } else {
          log("No user data found in Firestore for userId: $userId");
        }
      } else {
        log("User document does not exist for userId: $userId");
      }
    } catch (e) {
      log("login failed: $e");
    }
  }
}
