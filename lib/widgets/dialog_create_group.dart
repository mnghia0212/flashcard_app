
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DialogCreateGroup extends ConsumerStatefulWidget {
  const DialogCreateGroup({super.key});

  @override
  ConsumerState<DialogCreateGroup> createState() => _DialogCreateGroupState();
}

class _DialogCreateGroupState extends ConsumerState<DialogCreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingPageProvider);
    return isLoading
    ? const Center(child: CircularProgressIndicator())
    : AlertDialog(
      actions: [
        textButton(
            context: context,
            text: "Hủy bỏ",
            onPressed: () {
              context.pop();
            }),
        textButton(
            context: context,
            text: "Tạo",
            onPressed: () {
              createGroup();
            }),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        height: 80,
        width: context.deviceSize.width,
        child: CommonTextFormField(
          labelText: "Tên nhóm",
          icon: const Icon(Icons.abc),
          controller: groupNameController,
        ),
      ),
    );
  }

  void createGroup() async {
    final groupName = groupNameController.text.trim();
    final userId = supabase.auth.currentUser?.id;
    final userState = ref.watch(userProvider);
    final String userName = userState.user!.userName;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (groupName.isNotEmpty) {
      ref.read(isLoadingPageProvider.notifier).state = true;

      final newGroupDoc = FirebaseFirestore.instance.collection('groups').doc();
      final newGroupId = newGroupDoc.id;

      final group = Groups(
          groupId: newGroupId,
          groupName: groupName,
          createdBy: userId,
          createdAt: DateTime.now().toString());

      await ref
          .read(groupProvider.notifier)
          .createGroup(group, userId, userName)
          .then((value) {
        ref.read(isLoadingPageProvider.notifier).state = false;
        if (!mounted) {
          return;
        }
        context.pop();
        AppAlerts.showFlushBar(
            context, "Tạo nhóm thành công", AlertType.success);
      });
    } else {
      AppAlerts.showFlushBar(context, "Nhóm học phải có tên", AlertType.error);
    }
  }
}

TextButton textButton(
    {required BuildContext context,
    required String text,
    required Function() onPressed}) {
  return TextButton(
      onPressed: onPressed,
      child: DisplayText(
        text: text,
        color: context.colorScheme.primary,
      ));
}

Row rowTitleDialogCreateSet(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const Icon(Icons.folder),
          const Gap(5),
          DisplayText(
            text: "Nhóm học mới",
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ],
      ),
      IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))
    ],
  );
}
