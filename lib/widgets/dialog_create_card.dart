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

class DialogCreateCard extends ConsumerStatefulWidget {
  final String? setId;
  const DialogCreateCard({super.key, required this.setId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DialogCreateCardState();
}

class _DialogCreateCardState extends ConsumerState<DialogCreateCard> {
  final supabase = Supabase.instance.client;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        textButton(
            context: context, text: "Hủy bỏ", onPressed: () => context.pop()),
        textButton(
          onPressed: () {
            createCard(widget.setId);
          },
          context: context,
          text: "Tạo",
        ),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        height: 230,
        child: Column(
          children: [
            CommonTextFormField(
              maxLines: 3,
              labelText: "Câu hỏi",
              icon: const Icon(Icons.abc),
              controller: questionController,
            ),
            const Gap(10),
            CommonTextFormField(
              maxLines: 3,
              labelText: "Câu trả lời",
              icon: const Icon(
                Icons.description,
              ),
              controller: answerController,
            ),
          ],
        ),
      ),
    );
  }

  void createCard(String? setId) async {
    final answer = answerController.text;
    final question = questionController.text;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }

     if (setId == null) {
        AppAlerts.showFlushBar(
            context, "Lỗi: Không thể tạo thẻ vì thiếu thông tin bộ thẻ", AlertType.error);
        return;
    }

    if (answer.isNotEmpty && question.isNotEmpty) {
      final newCardDoc =
          FirebaseFirestore.instance.collection("flashcards").doc();

      final flashcardId = newCardDoc.id;
      final flashcard = Flashcards(
          flashcardId: flashcardId,
          userId: userId,
          frontContent: question,
          backContent: answer,
          createdAt: DateTime.now().toString());

      await ref
          .read(flashcardsProvider.notifier)
          .createCardInSet(flashcard, context, setId)
          .then((value) {
        context.pop();
        AppAlerts.showFlushBar(
            context, "Tạo thẻ thành công", AlertType.success);
      });
    } else {
      AppAlerts.showFlushBar(
          context, "Thẻ phải có đủ mặt trước và sau", AlertType.error);
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
              text: "Tạo thẻ mới",
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
