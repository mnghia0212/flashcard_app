import 'dart:developer';

import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/extensions.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final userState = ref.watch(userProvider);

    if (userState.user == null) {
        return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(), // Hiển thị loading hoặc thông báo lỗi
        ),
        );
    }

    final String userName = userState.user!.userName ?? "Error user name";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(10),
              _buildProfileCard(ref, colors, userName),
              const Gap(15),
              _buildPreferencesSection(),
              const Gap(15),
              _buildMoreSection(),
              const Spacer(),
              _buildLogOutButton(context, ref, colors),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    try {
      await supabase.auth.signOut();
      ref.read(userProvider.notifier).clearUser(ref);
      context.go('/firstLogin');
      log("success sign out");
    } catch (e) {
      log("error sign out: $e");
    }
  }

  // Phần hiển thị thông tin profile của người dùng
  Widget _buildProfileCard(WidgetRef ref, ColorScheme colors, String? userName) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const DisplayText(
        text: "Hồ sơ cá nhân",
        color: Colors.black,
      ),
      const Gap(10),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Avatar người dùng
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                  'lib/assets/images/flashcard_sets.png'), // Thay bằng ảnh đại diện của người dùng
            ),
            const Gap(15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayText(
                  text: userName ?? "Error username",
                  fontWeight: FontWeight.bold,
                ),
                const Gap(5),
                DisplayText(
                  text: (supabase.auth.currentUser!.email) ??
                      "Error when loading email",
                  fontSize: 14,
                )
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ]);
  }

  // Phần Preferences (Dark theme, Notifications, Language, Settings)
  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayText(
          text: "Ưa thích",
          color: Colors.black,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPreferenceItem(
                icon: Icons.dark_mode,
                title: "Giao diện tối",
                trailing: Switch(
                  value: false, // Thay đổi trạng thái theo dark theme của bạn
                  onChanged: (value) {
                    // Xử lý sự kiện bật/tắt dark theme
                  },
                ),
              ),
              _buildPreferenceItem(
                icon: Icons.notifications,
                title: "Thông báo",
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              _buildPreferenceItem(
                icon: Icons.language,
                title: "Ngôn ngữ",
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              _buildPreferenceItem(
                icon: Icons.settings,
                title: "Cài đặt",
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Phần More (Terms & Conditions, Help & Support)
  Widget _buildMoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DisplayText(
          text: "Khác",
          color: Colors.black,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPreferenceItem(
                icon: Icons.article,
                title: "Điều khoản & Chính sách",
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              _buildPreferenceItem(
                icon: Icons.help,
                title: "Giúp đỡ và hỗ trợ",
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        )
      ],
    );
  }

  // Tạo nút cho mỗi tùy chọn trong Preferences và More
  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: trailing,
    );
  }

  // Nút Log Out
  Widget _buildLogOutButton(
      BuildContext context, WidgetRef ref, ColorScheme colors) {
    return OutlinedButton.icon(
      onPressed: () {
        signOut(ref, context);
      },
      icon: Icon(
        Icons.power_settings_new,
        color: colors.primary,
      ),
      label: const DisplayText(
        text: "Đăng xuất",
        color: Colors.black,
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide(
          width: 2,
          color: colors.primary, // Đảm bảo thuộc tính side được áp dụng đúng
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
