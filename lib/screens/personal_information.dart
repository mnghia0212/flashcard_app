import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gap/gap.dart';

class PersonalInformation extends ConsumerWidget {
  final Users? userState;
  const PersonalInformation({super.key, required this.userState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController(text: userState!.email);
    final userNameController = TextEditingController(text: userState!.userName);
    final passwordController = TextEditingController(text: userState!.password);
    final colors = context.colorScheme;
    final sizes = context.deviceSize;

    return Scaffold(
      appBar: const CommonAppBar(title: "Thông tin người dùng"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: sizes.height * 0.85,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                    'assets/images/ava2.jpg'), // Thay bằng ảnh đại diện của người dùng
              ),
              const Gap(10),
              DisplayText(
                text: "Sửa",
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
              const Gap(30),
              CommonTextFormField(
                  controller: emailController,
                  labelText: "Địa chỉ email",
                  readOnly: true,
                  icon: const Icon(Icons.email_outlined)),
              const Gap(20),
              CommonTextFormField(
                  controller: userNameController,
                  labelText: "Tên người dùng",
                  icon: const Icon(Icons.person_outline)),
              const Gap(20),
              CommonTextFormField(
                  controller: passwordController,
                  isPassword: true,
                  labelText: "Mật khẩu",
                  icon: const Icon(Icons.lock_outline)),
              const Spacer(),
              SizedBox(
                width: sizes.width,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final updatedUser = userState!.copyWith(
                        userName: userNameController.text,
                        password: passwordController.text);
                
                    await ref
                        .read(userProvider.notifier)
                        .updateUser(updatedUser)
                        .then((value) {
                      if (!context.mounted) {
                        return;
                      }
                
                      context.pop();
                
                      AppAlerts.showFlushBar(
                          context,
                          "Cập nhật thông tin thành công",
                          AlertType.success);
                    });
                  },
                  label: const DisplayText(
                    text: "Cập nhật",
                    fontWeight: FontWeight.bold,
                  ),
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: colors.primary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
