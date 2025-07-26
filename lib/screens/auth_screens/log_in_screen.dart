import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/services/services.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isLoading = ref.watch(isLoadingPageProvider);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
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
                      validator: (String? value) {
                        final email = value!.trim();
                        if (email.isEmpty) {
                          return "Địa chỉ email trống";
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Password field
                    CommonTextFormField(
                      labelText: "Mật khẩu",
                      icon: const Icon(Icons.lock_outlined),
                      controller: passwordController,
                      isPassword: true,
                      validator: (String? value) {
                        final password = value!.trim();
                        if (password.isEmpty) {
                          return "Mật khẩu trống";
                        }
                        return null;
                      },
                    ),

                    const Gap(10),

                    RichText(
                        text: TextSpan(
                            style: const TextStyle(fontSize: 17),
                            children: [
                          const TextSpan(
                              text: "Quên mật khẩu? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "Bấm vào đây",
                              style: TextStyle(color: colorScheme.primary))
                        ])),

                    const Gap(20),
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

                    const Spacer(),
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
            ),
    );
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      ref.read(isLoadingPageProvider.notifier).state = true;

      try {
        final response = await supabase.auth.signInWithPassword(
            email: emailController.text, password: passwordController.text);

        if (response.user == null) {
          ref.read(isLoadingPageProvider.notifier).state = false;
          AppAlerts.showFlushBar(
              context, "Tài khoản không tồn tại", AlertType.error);
          log("login failed.");
          return; // Thoát sớm
        }

        final userId = response.user!.id;
        log("userId auth: $userId");

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          // Trường hợp đăng nhập thành công
          ref.read(userProvider.notifier).getUser();
          ref.read(userIdProvider.notifier).state = userId;
          ref.read(flushbarMessageProvider.notifier).state =
              "Đăng nhập thành công";

          log("login success");

          if (!mounted) return;

          ref.read(isLoadingPageProvider.notifier).state = false;
          context.go('/bottomNavigator');
        } else {
          // Trường hợp user không tồn tại trong Firestore
          ref.read(isLoadingPageProvider.notifier).state = false;
          AppAlerts.showFlushBar(
              context, "Tài khoản không tồn tại", AlertType.error);
          log("User document does not exist for userId: $userId");
        }
      } catch (error) {
        // Bắt lỗi nếu có sự cố ngoài mong đợi
        ref.read(isLoadingPageProvider.notifier).state = false;
        AppAlerts.showFlushBar(
            context, "Đã xảy ra lỗi, vui lòng thử lại", AlertType.error);
        log("Unexpected error: $error");
      }
    }
  }
}
