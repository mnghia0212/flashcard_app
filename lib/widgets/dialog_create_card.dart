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
  const DialogCreateCard({super.key});

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
            context: context,
            text: "Hủy bỏ",
            onPressed: () => context.pop()
        ),
        textButton(
            context: context,
            text: "Tạo",
            onPressed: () {
              
            }),
      ],
      title: rowTitleDialogCreateSet(context),
      contentPadding: const EdgeInsets.all(15),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            CommonTextFormField(
              labelText: "Định nghĩa",
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

  void createCard() async {

    

    await ref.read(flashcardsProvider.notifier).createCardInSet(flashcard, context, setId)
    context.pop();
    AppAlerts.showFlushBar(
        context, 
        "Tạo thẻ thành công", 
        AlertType.success
    );
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
