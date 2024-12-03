import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Users? userState;
  const ChangePasswordScreen({super.key, required this.userState});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  late String oldPassword;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    oldPassword = widget.userState!.password;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    reEnterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final sizes = context.deviceSize;

    if (widget.userState == null) {
      const Center(
        child: DisplayTitle(
          text: "Lỗi khi tải thông tin người dùng",
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Đổi mật khẩu"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: sizes.height * 0.85,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DisplayText(
                  text: "Vui lòng nhập lại mật khẩu cũ",
                  color: Colors.black,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
                const Gap(20),
                CommonTextFormField(
                  controller: oldPasswordController,
                  labelText: "Mật khẩu cũ",
                  icon: const Icon(Icons.lock_outline),
                  validator: (String? value) {
                    final password = value!.trim();
                    if (password.isEmpty) {
                      return "Mật khẩu cũ trống";
                    } else if (password != oldPassword) {
                      return "Mật khẩu cũ nhập sai";
                    } else {
                      return null;
                    }
                  },
                ),
                const Gap(20),
                CommonTextFormField(
                    controller: newPasswordController,
                    labelText: "Mật khẩu mới",
                    icon: const Icon(Icons.lock)),
                const Gap(20),
                CommonTextFormField(
                    controller: reEnterPasswordController,
                    labelText: "Nhập lại mật khẩu",
                    icon: const Icon(Icons.lock)),
                const Spacer(),
                _buildButtonChangePassword(colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildButtonChangePassword(ColorScheme colors) {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          log("accepted");
        }
      },
      label: const DisplayText(
        text: "Đổi mật khẩu",
        fontWeight: FontWeight.bold,
      ),
      icon: const Icon(
        Icons.system_update,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: colors.primary),
    );
  }
}
