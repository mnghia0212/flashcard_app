import 'dart:developer';

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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(30),
            const DisplayHeading(text: "Tạo tài khoản"),
            const Gap(30),

            // Username field
            CommonTextFormField(
              labelText: "Tên tài khoản",
              icon: const Icon(Icons.person_outline),
              controller: userNameController,
            ),
            const Gap(20),

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
            const Gap(20),
            CommonTextFormField(
              labelText: "Nhập lại mật khẩu",
              icon: const Icon(Icons.lock),
              controller: rePasswordController,
              isPassword: true,
            ),
            const Gap(20),

            //terms and policy
            richTextTermsPolicy(context),

            const Gap(30),

            //button sign up
            ElevatedButton(
              onPressed: () async {
                signup();
              },
              child: const DisplayText(
                text: "Đăng ký",
                color: Colors.black,
              ),
            ),

            const Gap(100),
            richTextNavigateLogin(context),
          ],
        ),
      ),
    );
  }

Future<void> signup() async {
  try {
    //sign up auth
    final response = await supabase.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
    );
    if (response.user == null) {
      log('Đăng ký không thành công');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký không thành công, vui lòng thử lại.")),
      );
      return; 
    }

    //store user to firestore
    final userId = response.user!.id;
    final Users user = Users(
      userId: userId, 
      userName: userNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    await ref.read(userProvider.notifier).createUser(user);
    ref.read(userIdProvider.notifier).state = userId;

    log("sign up success");

    //navigate home screen
    context.push('/bottomNavigator');
  } 

  //catch error
  catch (e) {
    log("Đăng ký thất bại: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đăng ký thất bại: $e")),
    );
  }
}


  RichText richTextNavigateLogin(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: const TextStyle(fontSize: 17),
        children: [
          const TextSpan(
            text: 'Bạn đã có Tài khoản ? ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
              text: 'Đăng nhập',
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.push("/logIn");
                }),
        ],
      ),
    );
  }

  RichText richTextTermsPolicy(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: const TextStyle(fontSize: 17),
        children: [
          const TextSpan(
            text: 'Khi đăng ký bạn đã đồng ý với ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
              text: 'Chính sách dịch vụ và Điều khoản bảo mật',
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) {
                        return const TermsPolicy();
                      });
                }),
        ],
      ),
    );
  }
}
