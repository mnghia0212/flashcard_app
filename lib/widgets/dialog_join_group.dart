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

class DialogJoinGroup extends ConsumerStatefulWidget {
  const DialogJoinGroup({super.key});

  @override
  ConsumerState<DialogJoinGroup> createState() => _DialogJoinGroupState();
}

class _DialogJoinGroupState extends ConsumerState<DialogJoinGroup> {
  final supabase = Supabase.instance.client;

  final TextEditingController groupIdController = TextEditingController();

  @override
  void dispose() {
    groupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.deviceSize;
    return AlertDialog(
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
              createCardSet();
            }),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        width: size.width,
        height: 100,
        child: CommonTextFormField(
          labelText: "Mã nhóm",
          icon: const Icon(Icons.abc),
          controller: groupIdController,
        ),
      ),
    );
  }

  void createCardSet() async {
    final groupId = groupIdController.text.trim();
    final userId = supabase.auth.currentUser?.id;
    final userState = ref.watch(userProvider);
    final String userName = userState.user!.userName;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

    if (groupId.isNotEmpty) {
      final newMemberDoc =
          FirebaseFirestore.instance.collection('flashcardSets').doc();
      final memberId = newMemberDoc.id;

      final newMember = GroupMembers(
          groupMemberId: memberId,
          groupId: groupId,
          userId: userId,
          groupMemberName: userName,
          joinedAt: DateTime.now().toString(),
          isAdmin: false);

      // await ref
      //     .read(flashcardSetsProvider.notifier)
      //     .createFlashcardSet(flashcardSet, context)
      //     .then((value) {
      //   if (!mounted) return;
      //   context.pop();
      //   AppAlerts.showFlushBar(
      //       context, "Đã gửi lời mời vào nhóm", AlertType.success);
      // });
    } else {
      AppAlerts.showFlushBar(context, "Chưa nhập mã nhóm", AlertType.error);
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
              text: "Tham gia nhóm",
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ],
        ),
        IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.close))
      ],
    );
  }
}
