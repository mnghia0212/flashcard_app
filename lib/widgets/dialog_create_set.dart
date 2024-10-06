import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flashcard_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DialogCreateSet extends ConsumerStatefulWidget {
  const DialogCreateSet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DialogCreateSetState();
}

class _DialogCreateSetState extends ConsumerState<DialogCreateSet> {
  final supabase = Supabase.instance.client;

  final TextEditingController setNameController = TextEditingController();
  final TextEditingController setDesController = TextEditingController();

  @override
  void dispose() {
    setNameController.dispose();
    setDesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        height: 180,
        child: Column(
          children: [
            CommonTextFormField(
              labelText: "Tên bộ thẻ",
              icon: const Icon(Icons.abc),
              controller: setNameController,
            ),
            const Gap(10),
            CommonTextFormField(
              maxLines: 3,
              labelText: "Mô tả",
              icon: const Icon(
                Icons.description,
              ),
              controller: setDesController,
            ),
          ],
        ),
      ),
    );
  }

  void createCardSet() async {
    final setName = setNameController.text.trim();
    final setDes = setDesController.text.trim();
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      SessionService().checkSession(context);
      return;
    }
    final setId = DateTime.now().toString();
    if (setName.isNotEmpty) {
      final flashcardSet = FlashcardSets(
        setId: setId,
        userId: userId,
        title: setName,
        description: setDes,
        isFavorite: false,
        createdAt: DateTime.now().toString(),
      );

      await ref
          .read(flashcardSetsProvider.notifier)
          .createFlashcardSet(flashcardSet, context)
          .then((value) {
        context.pop();
        AppAlerts.showFlushBar(
            context, "Tạo bộ thẻ thành công", AlertType.success);
      });
    } else {
      AppAlerts.showFlushBar(context, "Bộ thẻ phải có tên", AlertType.error);
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
              text: "Bộ thẻ mới",
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
