import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final Users? userState;
  const ChangePasswordScreen({super.key, required this.userState});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
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
                _buildOldPasswordField(),
                const Gap(20),
                _buildNewPasswordTextField(),
                const Gap(20),
                _buildReEnterPasswordTextField(),
                const Gap(20),
                 const DisplayText(
                  text: "Vui lòng nhập lại mật khẩu cũ và nhập mật khẩu mới",
                  color: Colors.black,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                _buildButtonChangePassword(colors, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(String newPassword, WidgetRef ref) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null || widget.userState != null) {
      try {
        changeFireStorePassword(newPassword, ref);
        changeSupabasePassword(newPassword);
        if (!mounted) {
          return;
        }
        context.pop();
        AppAlerts.showFlushBar(
            context, "Đổi mật khẩu thành công", AlertType.success);
      } catch (e) {
        log("error change pass: $e");
        if (!mounted) {
          return;
        }
        AppAlerts.showFlushBar(
            context, "Lỗi khi đổi mật khẩu", AlertType.error);
      }
    } else {
      log("no user logged in");
      if (!mounted) {
        return;
      }
      AppAlerts.showFlushBar(
          context, "Không có người dùng nào đăng nhập", AlertType.error);
    }
  }

  Future<void> changeFireStorePassword(
      String newPassword, WidgetRef ref) async {
    try {
      final updatedUser = widget.userState!.copyWith(password: newPassword);
      await ref.read(userProvider.notifier).updateUser(updatedUser);
    } catch (e) {
      log("error change pass in firestore: $e");
      if (!mounted) {
        return;
      }
      AppAlerts.showFlushBar(
          context, "Lỗi khi đổi mật khẩu :$e", AlertType.error);
    }
  }

  Future<void> changeSupabasePassword(String newPassword) async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      log("error change pass in supabase: $e");
      if (!mounted) {
        return;
      }
      AppAlerts.showFlushBar(context, "Lỗi khi đổi mật khẩu", AlertType.error);
    }
  }

  CommonTextFormField _buildReEnterPasswordTextField() {
    return CommonTextFormField(
      controller: reEnterPasswordController,
      isPassword: true,
      labelText: "Nhập lại mật khẩu",
      icon: const Icon(Icons.lock),
      validator: (String? value) {
        final password = value!.trim();
        if (password != newPasswordController.text.trim()) {
          return "Mật khẩu không giống nhau";
        }
        return null;
      },
    );
  }

  CommonTextFormField _buildNewPasswordTextField() {
    return CommonTextFormField(
        controller: newPasswordController,
        isPassword: true,
        labelText: "Mật khẩu mới",
        icon: const Icon(Icons.lock),
        validator: (String? value) {
          final password = value!.trim();
          if (password.isEmpty) {
            return "Mật khẩu trống";
          } else if (password.length < 9) {
            return "Mật khẩu phải đủ 8 ký tự";
          } else if (password == widget.userState!.password) {
            return "Mật khẩu mới không được giống mật khẩu cũ";
          }
          return null;
        });
  }

  CommonTextFormField _buildOldPasswordField() {
    return CommonTextFormField(
      controller: oldPasswordController,
      isPassword: true,
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
    );
  }

  ElevatedButton _buildButtonChangePassword(ColorScheme colors, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          await changePassword(newPasswordController.text.trim(), ref);
          log("password changed: ${newPasswordController.text}");
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
